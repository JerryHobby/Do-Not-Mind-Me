extends Node2D
@onready var npc = $NPC


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.on_debug.connect(on_debug)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_input()


func get_input() -> void:
	if Input.is_action_just_pressed("debug"):
		GameManager.set_debug(!GameManager.get_debug())

	if Input.is_action_just_pressed("music"):
		GameManager.set_music(!GameManager.get_music())

	if Input.is_action_just_pressed("sound"):
		GameManager.set_sound(!GameManager.get_sound())

	if Input.is_action_just_pressed("God Mode"):
		GameManager.set_god_mode(!GameManager.get_god_mode())



func on_debug() -> void:
	pass
