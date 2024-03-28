extends Node

const LEVEL_SCENE:PackedScene = preload("res://Scenes/level_map.tscn")
const MAIN_SCENE:PackedScene = preload("res://Scenes/main.tscn")

const GROUP_PLAYER = "player"
const GROUP_BULLET = "bullet"
const GROUP_NPC = "npc"
const GROUP_PICKUP = "pickup"

const PLAYER_SPEED:float = 250.0

const NPC_SPEED_PATROLLING:float = 130
const NPC_SPEED_CHASING:float = 160
const NPC_SPEED_SEARCHING:float = 150

const NPC_FOV_PATROLLING:float = 60
const NPC_FOV_CHASING:float = 120
const NPC_FOV_SEARCHING:float = 100

const NPC_SIGHT_RANGE_PATROLLING:float = 300.0
const NPC_SIGHT_RANGE_CHASING:float = 500.0
const NPC_SIGHT_RANGE_SEARCHING:float = 500.0

const NPC_BULLET_SPEED:float = 400.0
const NPC_SHOOT_DELAY:float = 1.75


const TEST_MODE:bool = false

var _debug:bool = false
var _music:bool = true
var _sound:bool = true
var _god_mode:bool = false
var _pause:bool = false
var _help:bool = true


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
	get_tree().paused = _pause
	
	SignalManager.on_pause.emit()
	if _debug:
		print("Pause: ", _pause)


#####
func get_help() -> bool:
	return _help


func set_help(v:bool) -> void:
	_help = v
	
	SignalManager.on_help.emit()
	if _debug:
		print("Help: ", _help)

