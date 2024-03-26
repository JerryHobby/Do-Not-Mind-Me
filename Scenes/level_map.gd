extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.on_debug.connect(on_debug)
	SignalManager.on_pickup.connect(on_pickup)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
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

	if Input.is_action_just_pressed("pause"):
		GameManager.set_pause(!GameManager.get_pause())

	if Input.is_action_just_pressed("help"):
		GameManager.set_help(!GameManager.get_help())



func on_pickup(remaining:int):

	if remaining == 0:
		print("Game Checkpoint Enabled")
	else:
		print("Pickups remaining: ", remaining)


func on_debug() -> void:
	pass
