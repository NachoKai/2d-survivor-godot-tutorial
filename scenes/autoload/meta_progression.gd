extends Node

# On desktop platforms the directory paths for user:// are:
# Windows: %APPDATA%\Godot\app_userdata\[project_name]
# macOS: ~/Library/Application Support/Godot/app_userdata/[project_name]
# To see the folder: Project -> Open User Data Folder
const SAVE_FILE_PATH: String = "user://game.save"

var save_data: Dictionary = {
	"meta_upgrade_currency": 0,
	"meta_upgrades": {}
}


func _ready():
	GameEvents.experience_vial_collected.connect(on_experience_collected)
	load_file()


func load_file():
	if not FileAccess.file_exists(SAVE_FILE_PATH): return
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	save_data = file.get_var()


func save_file():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_var(save_data)


func add_meta_upgrade(upgrade: MetaUpgrade):
	if not save_data["meta_upgrades"].has(upgrade.id):
		save_data["meta_upgrades"][upgrade.id] = {
			"quantity": 0
		}
	save_data["meta_upgrades"][upgrade.id]["quantity"] += 1
	save_file()


func get_upgrade_count(upgrade_id: String):
	if not upgrade_id: return
	if save_data["meta_upgrades"].has(upgrade_id):
		return save_data["meta_upgrades"][upgrade_id]["quantity"]
	return 0

func on_experience_collected(number: float):
	save_data["meta_upgrade_currency"] += number
