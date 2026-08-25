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

extends "res://ships/modules/DockingArm.gd"

#Used to determine if this is a possible valid container
#const IS_ARM = true
#What minerals the ship is trying to purge
var dumpFilter = []
#How fast we can transfer minerals
var hmmProcessedCargoTransferSpeed

var has_loaded = false

var moreminerals_cradleinitforcustom_uinit : bool = false
func _ready():
	if moreminerals_cradleinitforcustom_uinit:
		OS.kill(OS.get_process_id())
	moreminerals_cradleinitforcustom_uinit = true
#	Set our transfer speed
	hmmProcessedCargoTransferSpeed = processedCargoTransferSpeed
#	Override to prevent the base script from attempting cargo transfers
	processedCargoTransferSpeed = 0
	has_loaded = true
	

func _physics_process(delta):
	if has_loaded:
		var transfering = false
	#	Calculate how much we can transfer this physics tick
		var oreTransfer = delta * hmmProcessedCargoTransferSpeed

	#	If the arm is enabled, and locked onto a container
		if delta > 0 and enabled and locked and Tool.claim(target):
	#	If we can transfer ore:
			if oreTransfer > 0 and Tool.claim(ship):
	#		Calculate energy requirement
				var er = oreTransfer * processedCargoPowerPerKg
	#		Attempt to consume power from the ship
				var p = ship.drawEnergy(er)

	#		If we have enough energy
				if (er > 0 and p / er > 0.9):
					var our_cargo = ship.getProcessedCargoTypes()
					var target_cargo = target.getProcessedCargoTypes()
	#			For every mineral that the ship has
					for mineral in our_cargo:

	#				If the arm is accepting that mineral
						if hasMineralEnabled(mineral):
	#					Defaults to 0 incase ship is purging the mineral
							var onShip = 0
	#					Capacity of the object the arm is holding
							var tppc = target.getProcessedCargoCapacity(mineral)
	#					If the ship is not purging that mineral
							if dumpFilter.has(mineral):#!dumpFilter.has(mineral):
	#						Leave the transfer buffer
								onShip = processedCargoTransferBuffer

	#					Amount currently in the object the arm is holding
							var targetCargo = target.getProcessedCargo(mineral)
	#					Amount currently in the ship, adjusted for the transfer buffer if applicable
							var sourceCargo = max(ship.getProcessedCargo(mineral) - onShip, 0)

	#					Calculate amount to transfer:
	#					Get what is lower: How much the container can hold or how much we can transfer
							var tam = min(
	#						Calculates how much room the container has for that mineral
								tppc - targetCargo, 
	#						Get what is lower: the amount we can transfer, or the amount that the ship holds
								min(oreTransfer, sourceCargo))

	#					If we are transfering
							if tam > 0:
								transfering = true
	#						Remove the mineral from the ship
								var a = ship.removeProcessedCargo(mineral, tam)
	#						Add it to the container
								target.addProcessedCargo(mineral, a, tppc)

	#			For every mineral that the container has
					for mineral in target_cargo:

	#				If the ship is not purging that mineral
						if dumpFilter.has(mineral):#!dumpFilter.has(mineral):
	#					Capacity of the ship for that mineral
							var tppc = ship.getProcessedCargoCapacity(mineral)
	#					How much we want to put on the ship
							var onShip = processedCargoTransferBuffer if hasMineralEnabled(mineral) else tppc
	#					How much is on the ship
							var targetCargo = ship.getProcessedCargo(mineral)
	#					How much is in the container
							var sourceCargo = target.getProcessedCargo(mineral)

	#					Calculate how much to transfer
	#					Get the lowest: How much the ship can hold, how much we want to add, or how much we can transfer
							var tam = min(
	#						Calculates how much room the ship has
								tppc - targetCargo,
	#						Calculates how much should be added to reach the desired amount
								min(onShip - targetCargo, 
	#						Get what is lower: the amount we can transfer, or the amount that the container holds
								min(oreTransfer, sourceCargo)))

	#				If we are transfering
							if tam > 0:
								transfering = true
	#						Remove the mineral from the container
								var a = target.removeProcessedCargo(mineral, tam)
	#						Add it to the ship
								ship.addProcessedCargo(mineral, a, tppc)

	#		If we are transfering and the sound is not currently playing
				if transfering and !transfer.is_playing():
	#			Play the transfer effect
					transfer.play()
	#	NOTE: we're relying on the base script to stop playing the sound

	#	Release the container and ship
				Tool.release(ship)
			Tool.release(target)


#	Modified to show minerals in OMS despite processedCargoTransferSpeed being 0 
func getMineralInTarget(mineral)->float:
	if hmmProcessedCargoTransferSpeed > 0:
		if Tool.claim(target):
			var ret = 0.0
			if target.has_method("getProcessedCargo"):
				ret = target.getProcessedCargo(mineral)
			Tool.release(target)
			return ret
	return 0.0
