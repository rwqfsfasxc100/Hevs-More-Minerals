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

extends Node


# name of the equipment
var systemName = "SYSTEM_CARGO_PROCESSED"
# The equipment slot on the ship
var slot = "cargo.processed"
# Set so that it shows up in the OMS
var mineralTargetting = true
# We only want minerals
var onlyMinerals = true
# The filter that will determine what minerals we store
var mineralConfig = []
# How quickly the ship can purge minerals
var dumpRate = 500.0

# The ship we belong to
var ship
# Any equiment that can hold minerals
var containers = []


# Needed for the ship to detect it as a system
func getStatus():
	return 100

var reset_filters = true
# Returns how full the processed cargo is, used to modulate the equipment brightness on the HUD
func getPower():
	var t : float = ship.getTotalProcessedCargoCapacity()
	var c : float = 0.0
	for m in ship.shipConfig.processedCargo:
		c += ship.shipConfig.processedCargo[m]

	return (c / t)
var ringMinerals = CurrentGame.traceMinerals.duplicate(true)
var pointersHMM
# Called when the node enters the scene tree for the first time.
func _ready():
	pointersHMM = ModLoader._savedObjects[0]
	pointersHMM.ConfigDriver.__establish_connection("hmm_control_update_values",self)
	hmm_processed_cargo_scene_UV()
	
	
	ship = getShip()
	ship.connect("systemsChanged", self, "getSystems")
	#If we're mineraltargeting
	if mineralTargetting:
		#Get the filter from the ship
		if reset_filters:
			mineralConfig = ringMinerals.duplicate(true)
		else:
			mineralConfig = ship.getConfig("cargo.pfilter", ringMinerals.duplicate(true))

func hmm_processed_cargo_scene_UV():
	if pointersHMM:
		reset_filters = pointersHMM.ConfigDriver.__get_value("Hev'sMoreMinerals","MOREMINERALS_SECTION_ORE_HANDLING","reset_eject_processed_ore_filters")

#Enables/Disables given mineral, called whenever geologist filters are changed
func setMineralConfig(mineral:String, how:bool):
	if mineralTargetting:
		if how:
			if not mineralConfig.has(mineral):
				mineralConfig.append(mineral)
		else :
			mineralConfig.erase(mineral)

	setFilters()


#Checks if the mineral is enabled, used by  the geologist menu to determine what buttons should be pressed
func hasMineralEnabled(mineral)->bool:
	if mineralTargetting:
		return mineralConfig.has(mineral)
	else :
		return false


func _physics_process(delta):
#	Check what minerals we need to handle this tick
	for m in ringMinerals:
		if not m in mineralConfig:
#		Check if any containers have empty space
			var dump = true
			for c in containers:
				if Tool.claim(c):
					if c.enabled and c.locked and c.mineralTargetting and c.mineralConfig.minerals.has(m):
						if Tool.claim(c.target):
							if c.target.getProcessedCargo(m) < c.target.getProcessedCargoCapacity(m):
								dump = false
								Tool.release(c.target)
								Tool.release(c)
								break
							Tool.release(c.target)
					Tool.release(c)

#		If there is no empty space, dump the mineral
			if dump:
				dumpMineral(m, delta)



func dumpMineral(m, d):
	var dumped = ship.removeProcessedCargo(m, dumpRate*d)


# Get the ship we belong to
func getShip():
	var c = self
	while not c.has_method("getConfig") and c != null:
		c = c.get_parent()
	return c


# Get references to the systems we need
func getSystems(systems):
	containers = []
	for id in systems:
		var s = systems[id].ref

		if "system" in s:
			if "dumpFilter" in s.system:
				containers.append(s.system)

	setFilters()


func setFilters():
	for c in containers:
		if Tool.claim(c):
			c.dumpFilter = mineralConfig
			Tool.release(c)


# Shows what minerals are in the ship on the OMS
func getMineralInTarget(mineral)->float:
	if Tool.claim(ship):
		var ret = ship.getProcessedCargo(mineral)
		Tool.release(ship)
		return ret
	return 0.0
