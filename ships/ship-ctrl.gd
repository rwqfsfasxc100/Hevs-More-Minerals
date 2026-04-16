extends "res://ships/ship-ctrl.gd"


const baseMineralCount = 6.0

var extendedMineralCount = 6.0
var cargoCapacityModifier = 1.0

var cargoBehavior = "MOREMINERALS_CARGO_BEHAVIOUR_LIMITED" #[MOREMINERALS_CARGO_BEHAVIOUR_DEFAULT, MOREMINERALS_CARGO_BEHAVIOUR_REDUCED, MOREMINERALS_CARGO_BEHAVIOUR_LIMITED, MOREMINERALS_CARGO_BEHAVIOUR_DYNAMIC]
var maxCargoTypes = 6 #For use with "MOREMINERALS_CARGO_BEHAVIOUR_LIMITED" and "MOREMINERALS_CARGO_BEHAVIOUR_DYNAMIC" cargo behaviors

var cargoScene = preload("res://Hevs-More-Minerals/ships/modules/ProcessedCargo.tscn")


func _ready():
	extendedMineralCount = float(CurrentGame.traceMinerals.size())
	cargoCapacityModifier = (baseMineralCount / extendedMineralCount)

	if playerControlled:
		add_child(cargoScene.instance())

	pointersHMM = get_tree().get_root().get_node_or_null("HevLib~Pointers")
	pointersHMM.ConfigDriver.__establish_connection("hmm_control_update_values",self)
	hmm_control_update_values()

# Get a ship's total processed cargo capacity
func getTotalProcessedCargoCapacity()->float:
	if processedCargoStorageType == "divided":
		match cargoBehavior:
			"MOREMINERALS_CARGO_BEHAVIOUR_DEFAULT":
				return processedCargoCapacity * extendedMineralCount
			"MOREMINERALS_CARGO_BEHAVIOUR_REDUCED", "MOREMINERALS_CARGO_BEHAVIOUR_LIMITED", "MOREMINERALS_CARGO_BEHAVIOUR_DYNAMIC":
				return processedCargoCapacity * baseMineralCount
			_:
				return 0.0
	else:
		return .getTotalProcessedCargoCapacity()
var pointersHMM


func hmm_control_update_values():
	if pointersHMM:
		cargoBehavior = pointersHMM.ConfigDriver.__get_value("Hev'sMoreMinerals","MOREMINERALS_SECTION_ORE_HANDLING","cargo_behaviour")
		maxCargoTypes = pointersHMM.ConfigDriver.__get_value("Hev'sMoreMinerals","MOREMINERALS_SECTION_ORE_HANDLING","max_cargo_types")

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
		for i in range(baseMineralCount):
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
