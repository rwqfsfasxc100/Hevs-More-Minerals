# [license]
# 3-Clause BSD NON-AI License
# 
# Copyright 2026 __hev (Benjamin Buckhurst)
# 
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
# 
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer
# in the documentation and/or other materials provided with the distribution.
# 
# 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products
# derived from this software without specific prior written permission.
# 
# 4. The source code and the binary form, and any modifications made to them may not be used for the purpose of input data, reference code snippets and/or files, OR used in the training of, or improvement of machine learning algorithms,
# including but not limited to artificial intelligence, natural language processing, or data mining. This condition applies to any derivatives,
# modifications, or updates based on the Software code. Any usage of the source code or the binary form may not be present in any form as data fed, inputted, or provided to an AI, or present in any AI-training dataset is considered a breach of this License.
# 
# 5. Any projects deriving work from this project MUST include a copy of this license and all other license and/or copyright agreements posed within other source material,
# all of which must be followed to its entirety. Failure to follow these licenses prohibit all modification and redistribution of the material until all licensing has been reinstated.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS “AS IS” AND ANY EXPRESS OR IMPLIED WARRANTIES,
# INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
# OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
# EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# [/license]

extends "res://ships/ship-ctrl.gd"


const baseMineralCount = 6.0

var extendedMineralCount = 6.0
var cargoCapacityModifier = 1.0

var cargoBehavior = "MOREMINERALS_CARGO_BEHAVIOUR_LIMITED" #[MOREMINERALS_CARGO_BEHAVIOUR_DEFAULT, MOREMINERALS_CARGO_BEHAVIOUR_REDUCED, MOREMINERALS_CARGO_BEHAVIOUR_LIMITED, MOREMINERALS_CARGO_BEHAVIOUR_DYNAMIC]
var maxCargoTypes = 6 #For use with "MOREMINERALS_CARGO_BEHAVIOUR_LIMITED" and "MOREMINERALS_CARGO_BEHAVIOUR_DYNAMIC" cargo behaviors

var cargoScene = preload("res://Hevs-More-Minerals/ships/modules/ProcessedCargo.tscn")

var processedStorageToggles = true

var moreminerals_shipprocessedstoragehandler_uinit : bool = false
func _ready():
	if moreminerals_shipprocessedstoragehandler_uinit:
		OS.kill(OS.get_process_id())
	moreminerals_shipprocessedstoragehandler_uinit = true
	extendedMineralCount = float(CurrentGame.traceMinerals.size())
	cargoCapacityModifier = (baseMineralCount / extendedMineralCount)
	
	pointersHMM = ModLoader._savedObjects[0]
	pointersHMM.ConfigDriver.__establish_connection("hmm_control_update_values",self)
	hmm_control_update_values()
	
	
	
	if processedStorageToggles and isPlayerControlled():
		add_child(cargoScene.instance())


# Get a ship's total processed cargo capacity
func getTotalProcessedCargoCapacity()->float:
	if processedCargoStorageType == "divided":
		match cargoBehavior:
			"MOREMINERALS_CARGO_BEHAVIOUR_DEFAULT":
				return processedCargoCapacity * extendedMineralCount
			"MOREMINERALS_CARGO_BEHAVIOUR_REDUCED":
				return processedCargoCapacity * baseMineralCount
			"MOREMINERALS_CARGO_BEHAVIOUR_LIMITED", "MOREMINERALS_CARGO_BEHAVIOUR_DYNAMIC":
				return processedCargoCapacity * maxCargoTypes
#			"MOREMINERALS_CARGO_BEHAVIOUR_REDUCED", "MOREMINERALS_CARGO_BEHAVIOUR_LIMITED", "MOREMINERALS_CARGO_BEHAVIOUR_DYNAMIC":
#				return processedCargoCapacity * baseMineralCount
			_:
				return 0.0
	else:
		return .getTotalProcessedCargoCapacity()
var pointersHMM


func hmm_control_update_values():
	if pointersHMM:
		cargoBehavior = pointersHMM.ConfigDriver.__get_value("Hev'sMoreMinerals","MOREMINERALS_SECTION_ORE_HANDLING","cargo_behaviour")
		maxCargoTypes = pointersHMM.ConfigDriver.__get_value("Hev'sMoreMinerals","MOREMINERALS_SECTION_ORE_HANDLING","max_cargo_types")
		processedStorageToggles = pointersHMM.ConfigDriver.__get_value("Hev'sMoreMinerals","MOREMINERALS_SECTION_ORE_HANDLING","eject_processed_ore")
		
# Get a ship's processed cargo capacity for a single mineral
func getProcessedCargoCapacity(mineral:String)->float:
	removeSchrodingersIron()
	if setup:
		respect_limits()
	else:
		Tool.deferCallInPhysics(self,"respect_limits",[true])
	if setup and processedCargoStorageType == "divided":
		match cargoBehavior:

			"MOREMINERALS_CARGO_BEHAVIOUR_DEFAULT":
				return .getProcessedCargoCapacity(mineral)

			"MOREMINERALS_CARGO_BEHAVIOUR_REDUCED":
				return (processedCargoCapacity * cargoCapacityModifier)

			"MOREMINERALS_CARGO_BEHAVIOUR_LIMITED":
#				yield(get_tree(),"idle_frame")
				var types = getProcessedCargoTypes()
				if types.size() > maxCargoTypes:
					return 0.0
				if types.size() == maxCargoTypes:
					if mineral in types:
						return processedCargoCapacity
					else:
						return 0.0
				return processedCargoCapacity

			"MOREMINERALS_CARGO_BEHAVIOUR_DYNAMIC":
				var baysFree = maxCargoTypes

				for m in shipConfig.processedCargo:
					baysFree -= ceil(shipConfig.processedCargo[m] / processedCargoCapacity)

				if mineral in shipConfig.processedCargo:
					var currentBays = ceil(shipConfig.processedCargo[mineral] / processedCargoCapacity)
					return float((currentBays + baysFree) * processedCargoCapacity)
				else:
					return float(baysFree * processedCargoCapacity)
			_:
				return 0.0
	else:
		return .getProcessedCargoCapacity(mineral)

func respect_limits(postready = false):
	if cargoBehavior == "MOREMINERALS_CARGO_BEHAVIOUR_LIMITED" or cargoBehavior == "MOREMINERALS_CARGO_BEHAVIOUR_DYNAMIC":
		configMutex.lock()
		var entries = shipConfig.processedCargo.keys()
		if postready:
			randomize()
			entries.shuffle()
		for i in range(maxCargoTypes):
			entries.pop_front()
		for i in entries:
			shipConfig.processedCargo.erase(i)
		configMutex.unlock()

# Remove any processed cargo listings if it has 0 or less of that mineral.
# This prevents weird bugs with some custom cargo implementations, as the ship would start with 0 Iron in the hold.
func removeSchrodingersIron():
	configMutex.lock()
	if shipConfig.keys().size() >= 1:
		for mineral in shipConfig.processedCargo:
			if shipConfig.processedCargo[mineral] <= 0:
				shipConfig.processedCargo.erase(mineral)
	configMutex.unlock()
