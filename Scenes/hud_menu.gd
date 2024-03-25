extends Node2D
@onready var music_label = $ColorRect/HBoxContainer/MusicLabel
@onready var sound_label = $ColorRect/HBoxContainer/SoundLabel
@onready var debug_label = $ColorRect/HBoxContainer/DebugLabel
@onready var pause_label = $ColorRect/HBoxContainer/PauseLabel
@onready var god_mode_label = $ColorRect/HBoxContainer/GodModeLabel
@onready var camera_2d = $".."


# Called when the node enters the scene tree for the first time.
func _ready():
	set_labels()
	SignalManager.on_debug.connect(set_labels)
	SignalManager.on_music.connect(set_labels)
	SignalManager.on_sound.connect(set_labels)
	SignalManager.on_god_mode.connect(set_labels)
	SignalManager.on_pause.connect(set_labels)


func set_labels():
	var debugstate = "on" if GameManager.get_debug() else "off"
	var soundstate = "on" if GameManager.get_sound() else "off"
	var musicstate = "on" if GameManager.get_music() else "off"
	var godmodestate = "on" if GameManager.get_god_mode() else "off"
	var pausestate = "on" if GameManager.get_pause() else "off"

	debug_label.text = "(D)ebug: %s" % debugstate

	sound_label.text = "(S)ound: %s" % soundstate
	music_label.text = "(M)usic: %s" % musicstate
	pause_label.text = "(P)ause: %s" % pausestate
	god_mode_label.text = "(G)od Mode: %s" % godmodestate
	#
	#position = get_viewport_rect().size
	#position.x /= 2
	#position.y /= -2
	#print("HUD p: %s / rect: %s" % [position, get_viewport_rect().size] )

