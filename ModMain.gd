extends Node

# Set mod priority if you want it to load before/after other mods
# Mods are loaded from lowest to highest priority, default is 0
const MOD_PRIORITY = -10
# Name of the mod, used for writing to the logs
const MOD_NAME = "Hev's More Minerals"
const MOD_VERSION_MAJOR = 1
const MOD_VERSION_MINOR = 4
const MOD_VERSION_BUGFIX = 1
const MOD_VERSION_METADATA = ""

# Path of the mod folder, automatically generated on runtime
var modPath:String = get_script().resource_path.get_base_dir() + "/"
# Required var for the replaceScene() func to work
var _savedObjects := []

#Initialize the mod
func _init(modLoader = ModLoader):
	l("Initializing")

	var self_path = self.get_script().get_path()
	var self_directory = self_path.split(self_path.split("/")[self_path.split("/").size() - 1])[0]
	var self_check = load(self_directory + "mod_checker_script.tscn").instance()
	add_child(self_check)
#	Install our script extensions
#	initAsteroids()
	initHUD()
#	initShip()
	initElse()
#	installScriptExtension("new_script.gd")
	l("Initialized")


#func initAsteroids():
#	installScriptExtension("asteroids/mineral.gd")
#	installScriptExtension("AsteroidSpawner.gd")

func initHUD():
	replaceScene("hud/components/MineralSystemLabel.tscn")
	installScriptExtension("hud/components/MineralLabel.gd")
	installScriptExtension("hud/SystemMineralList.gd")

func initShip():
	installScriptExtension("ships/modules/DockingArm.gd")
	installScriptExtension("ships/modules/MineralProcessingUnit.gd")
#	installScriptExtension("ships/ship-ctrl.gd")
	

func initElse():
#	installScriptExtension("TheRing.gd")
#	installScriptExtension("CurrentGame.gd")
#	installScriptExtension("story/LifepodIsFloating.gd")
#	replaceScene("story/TheRing.tscn")

	replaceScene("comms/conversation/HabitatConversation.tscn")


#Do stuff on ready 
func _ready():
#	Add our translations
	updateTL("i18n/en.txt", "|")

	l("Ready")

# Helper script to load translations using csv format
# `path` is the path to the transalation file
# `delim` is the symbol used to seperate the values
# `useRelativePath` setting it to false uses a `res://` relative path instead of relative to the file
# `fullLogging` setting it to false reduces the number of logs written to only display the number of translations made
# example usage: updateTL("i18n/translation.txt", "|")
func updateTL(path:String, delim:String = ",", useRelativePath:bool = true, fullLogging:bool = true):
	if useRelativePath:
		path = str(modPath + path)
	l("Adding translations from: %s" % path)
	var tlFile:File = File.new()
	tlFile.open(path, File.READ)

	var translations := []
	
	var translationCount = 0
	var csvLine := tlFile.get_line().split(delim)
	if fullLogging:
		l("Adding translations as: %s" % csvLine)
	for i in range(1, csvLine.size()):
		var translationObject := Translation.new()
		translationObject.locale = csvLine[i]
		translations.append(translationObject)

	while not tlFile.eof_reached():
		csvLine = tlFile.get_csv_line(delim)

		if csvLine.size() > 1:
			var translationID := csvLine[0]
			for i in range(1, csvLine.size()):
				translations[i - 1].add_message(translationID, csvLine[i].c_unescape())
			if fullLogging:
				l("Added translation: %s" % csvLine)
			translationCount += 1

	tlFile.close()

	for translationObject in translations:
		TranslationServer.add_translation(translationObject)
	l("%s Translations Updated" % translationCount)


# Helper function to extend scripts
# Loads the script you pass, checks what script is extended, and overrides it
func installScriptExtension(path:String):
	var childPath:String = str(modPath + path)
	var childScript:Script = ResourceLoader.load(childPath)

	childScript.new()

	var parentScript:Script = childScript.get_base_script()
	var parentPath:String = parentScript.resource_path

	l("Installing script extension: %s <- %s" % [parentPath, childPath])

	childScript.take_over_path(parentPath)


# Helper function to replace scenes
# Can either be passed a single path, or two paths
# With a single path, it will replace the vanilla scene in the same relative position
func replaceScene(newPath:String, oldPath:String = ""):
	l("Updating scene: %s" % newPath)

	if oldPath.empty():
		oldPath = str("res://" + newPath)

	newPath = str(modPath + newPath)

	var scene := load(newPath)
	scene.take_over_path(oldPath)
	_savedObjects.append(scene)
	l("Finished updating: %s" % oldPath)


# Instances Settings.gd, loads DLC, then frees the script.
func loadDLC():
	l("Preloading DLC as workaround")
	var DLCLoader:Settings = preload("res://Settings.gd").new()
	DLCLoader.loadDLC()
	DLCLoader.queue_free()
	l("Finished loading DLC")


# Func to print messages to the logs
func l(msg:String, title:String = MOD_NAME, version:String = str(MOD_VERSION_MAJOR) + "." + str(MOD_VERSION_MINOR) + "." + str(MOD_VERSION_BUGFIX)):
	if not MOD_VERSION_METADATA == "":
		version = version + "-" + MOD_VERSION_METADATA
	Debug.l("[%s V%s]: %s" % [title, version, msg])
