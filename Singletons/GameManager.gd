extends Node

var _debug:bool = true
var _music:bool = false
var _sound:bool = false
var _god_mode:bool = false

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
	if _debug:
		print("Music: ", _music)


#####
func get_sound() -> bool:
	return _sound

func set_sound(v:bool) -> void:
	_sound = v
	if _debug:
		print("Sound: ", _sound)


#####
func get_god_mode() -> bool:
	return _god_mode

func set_god_mode(v:bool) -> void:
	_god_mode = v
	if _debug:
		print("God Mode: ", _god_mode)






