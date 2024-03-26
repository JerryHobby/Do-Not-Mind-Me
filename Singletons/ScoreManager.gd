extends Node

var _score = 0

const BONUS:int = 100
const LEVEL_COMPLETE = 5000
const NPC_KILLED = 1000

func bonus() -> void:
	_score += BONUS
	SignalManager.on_score_updated.emit(_score)


func level(level:int) -> void:
	_score += level * LEVEL_COMPLETE
	SignalManager.on_score_updated.emit(_score)


func npc_died() -> void:
	_score += NPC_KILLED
	SignalManager.on_score_updated.emit(_score)


