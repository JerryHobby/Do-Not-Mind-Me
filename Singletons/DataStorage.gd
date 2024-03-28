extends Node

const DATA_PATH:String = "user://scores.json"

var _data = {
	"high_score": 0
}

func _ready():
	load_data()


func load_data() -> bool:
	var file = FileAccess.open(DATA_PATH, FileAccess.READ)
	if !file:
		return false
	_data = JSON.parse_string(file.get_as_text())
	
	if _data == null:
		reset_high_score()
		
	return true


func get_high_score() -> int:
	return _data["high_score"]


func reset_high_score() -> void:
	_data = {
		"high_score": 0
	}
	var file = FileAccess.open(DATA_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(_data))
	file.close()
	ScoreManager.set_high_score()


func save_data():
	_data = {
		"high_score": ScoreManager.get_high_score()
	}

	var file = FileAccess.open(DATA_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(_data))
	file.close()
