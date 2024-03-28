extends Node

var _score:int = 0
var _high_score:int = 0

const BONUS:int = 100
const LEVEL_COMPLETE = 5000
const NPC_KILLED = 1000

var _cheats_used:bool = false

func _ready():
	SignalManager.on_god_mode.connect(on_god_mode)
	_high_score = DataStorage.get_high_score()


func bonus() -> void:
	add_to_score(BONUS)


func level(current_level:int) -> void:
	add_to_score(current_level * LEVEL_COMPLETE)


func npc_died() -> void:
	add_to_score(NPC_KILLED)


func get_score() -> int:
	return _score


func reset() -> void:
	_score = 0
	_cheats_used = false
	GameManager.set_god_mode(false)
	SignalManager.on_score_updated.emit(_score)


func on_god_mode():
	if GameManager.get_god_mode() == true:
		_cheats_used = true


func add_to_score(score:int) -> void:
	_score += score
	set_high_score()
	
	SignalManager.on_score_updated.emit(_score)


func set_high_score() -> void:
	if _score < _high_score or _cheats_used:
		return
	
	_high_score = _score
	save_high_score()


func save_high_score():
	DataStorage.save_data()


func used_cheats() -> bool:
	return _cheats_used


func get_high_score() -> int:
	if _high_score > 0:
		return _high_score

	#### read from file
	return DataStorage.get_high_score()


