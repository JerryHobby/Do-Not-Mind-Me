extends Node

const GROUP_PLAYER = "player"
const GROUP_BULLET = "bullet"
const GROUP_NPC = "npc"


const NPC_SPEED:float = 350.0
const PLAYER_SPEED:float = 350.0

var _debug:bool = true
var _music:bool = false
var _sound:bool = false
var _god_mode:bool = false
var _pause:bool = false

#####
func set_debug(v:bool) -> void:
	_debug = v
	SignalManager.on_debug.emit()

func get_debug() -> bool:
	return _debug

#####
func get_music() -> bool:
	return _music

func set_music(v:bool) -> void:
	_music = v
	SignalManager.on_music.emit()
	if _debug:
		print("Music: ", _music)


#####
func get_sound() -> bool:
	return _sound

func set_sound(v:bool) -> void:
	_sound = v
	SignalManager.on_sound.emit()
	if _debug:
		print("Sound: ", _sound)


#####
func get_god_mode() -> bool:
	return _god_mode

func set_god_mode(v:bool) -> void:
	_god_mode = v
	SignalManager.on_god_mode.emit()
	if _debug:
		print("God Mode: ", _god_mode)


#####
func get_pause() -> bool:
	return _pause

func set_pause(v:bool) -> void:
	_pause = v
	SignalManager.on_pause.emit()
	if _debug:
		print("Pause: ", _pause)






