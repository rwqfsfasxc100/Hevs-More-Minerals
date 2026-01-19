extends Node

const MOD_PRIORITY = -10
const MOD_NAME : String = "MoreMinerals"
const MOD_VERSION = "1.4.0"
const MOD_VERSION_MAJOR = 1
const MOD_VERSION_MINOR = 4
const MOD_VERSION_BUGFIX = 1
const MOD_VERSION_METADATA = ""
var modPath : String = get_script().resource_path.get_base_dir() + "/"
var _savedObjects = []


const PRIORITY_LIST = [
	{
		"priority":0, "func":"initAsteroids"
	},
	{
		"priority":1, "func":"initHUD"
	},
	{
		"priority":2, "func":"initShip"
	},
	{
		"priority":3, "func":"initElse"
	},
]



# Helper script to load translations
func updateTL(csvPath:String, delim:String = ","):
	l("Adding translations from: %s" % csvPath)
	var tlFile = File.new()
	tlFile.open(csvPath, File.READ)

	var translations = []

	var csvLine = tlFile.get_line().split(delim)
	l("Adding translations as: %s" % csvLine)
	for i in range(1, csvLine.size()):
		var translationObject = Translation.new()
		translationObject.locale = csvLine[i]
		translations.append(translationObject)

	while not tlFile.eof_reached():
		csvLine = tlFile.get_csv_line(delim)

		if csvLine.size() > 1:
			var translationID = csvLine[0]
			for i in range(1, csvLine.size()):
				translations[i - 1].add_message(translationID, csvLine[i].c_unescape())
			l("Added translation: %s" % csvLine)

	tlFile.close()

	for translationObject in translations:
		TranslationServer.add_translation(translationObject)

	l("Translations Updated")


# Helper function to extend scripts
func installScriptExtension(path:String):
	var childPath = str(modPath + path)
	var childScript = ResourceLoader.load(childPath)

	childScript.new()

	var parentScript = childScript.get_base_script()
	var parentPath = parentScript.resource_path

	l("Installing script extension: %s <- %s" % [parentPath, childPath])

	childScript.take_over_path(parentPath)


# Helper function to replace scenes
func replaceScene(path:String, oldPath:String = ""):
	l("Updating scene: %s" % path)
	var newScene
	var oldScene

	if oldPath == "":
		newScene = str(modPath + path)
		oldScene = str("res://" + path)

	else:
		newScene = path
		oldScene = oldPath

	var scene = load(newScene)
	scene.take_over_path(oldScene)
	_savedObjects.append(scene)
	l("Finished updating: %s" % oldScene)


# Func to print messages to the logs
func l(msg:String, title:String = MOD_NAME):
	Debug.l("[%s]: %s" % [title, msg])
