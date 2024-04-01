extends Node2D
@onready var exit = $Exit
@onready var sound = $Sound
@onready var exit_points = $ExitPoints
@onready var exit_points_tests = $ExitPointsTests
@onready var game_over_screen = $GameOverScreen

@onready var hud = $Camera2D/hud

var _pickups:int 
var _pickups_collected:int = 0

var elapsed_time:float = 0

func _ready():
	SignalManager.on_debug.connect(on_debug)
	SignalManager.on_pickup.connect(on_pickup)
	SignalManager.on_music.connect(on_music)
	SignalManager.on_level_complete.connect(on_level_complete)
	SignalManager.on_player_died.connect(on_player_died)
	
	GameManager.set_god_mode(false)
	_pickups = get_tree().get_nodes_in_group(GameManager.GROUP_PICKUP).size()
	#ScoreManager.reset()
	
	hud.on_pickup_update(_pickups)
	on_music()


func _process(_delta):
	get_input()
	if GameManager.get_pause() == false:
		var old_elapsed_time = int(elapsed_time)
		elapsed_time += _delta
		if int(elapsed_time) > old_elapsed_time:
			SignalManager.on_elapsed_time.emit(elapsed_time)


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
		if game_over_screen.visible == false:
			GameManager.set_pause(!GameManager.get_pause())

	if Input.is_action_just_pressed("help"):
		GameManager.set_help(!GameManager.get_help())
		
	if Input.is_action_just_pressed("fire"):
		if game_over_screen.visible == true:
			GameManager.next_level()


	if Input.is_action_just_pressed("quit"):
		GameManager.set_pause(false)
		get_tree().change_scene_to_packed(GameManager.MAIN_SCENE)


func on_pickup():
	_pickups_collected += 1
	var remaining = _pickups - _pickups_collected
	hud.on_pickup_update(remaining)
	
	if GameManager.TEST_MODE == true:
		exit_show()
	elif remaining == 0 and is_instance_valid(exit):
		exit_show()


func exit_show() -> void:
	var point
	
	if exit.visible == true:
		return

	if GameManager.TEST_MODE:
		point = exit_points_tests.get_children().pick_random()
	else:
		point = exit_points.get_children().pick_random()
	
	exit.global_position = point.global_position
	exit.show()
	exit.process_mode = Node.PROCESS_MODE_INHERIT


func on_debug() -> void:
	pass


func on_music() -> void:
	SoundManager.play_soundtrack(sound)


func on_level_complete(_level: int) -> void:
	GameManager.set_pause(true)
	game_over_screen.show()


func on_player_died() -> void:
	if GameManager.get_god_mode():
		return
	GameManager.set_pause(true)
	game_over_screen.show()

