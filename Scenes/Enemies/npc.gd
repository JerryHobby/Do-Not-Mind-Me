extends CharacterBody2D
@onready var debug_label = $DebugLabel
@onready var sprite_2d = $Sprite2D
@onready var nav_agent = $NavAgent


func _ready():
	SignalManager.on_debug.connect(on_debug)
	on_debug()

func _physics_process(delta):	
	if Input.is_action_pressed("set_target"):
		nav_agent.target_position = get_global_mouse_position()
		
	update_navigation()
	set_labels()


func update_navigation() -> void:
	if nav_agent.is_navigation_finished():
		return
		
	var next_path_position:Vector2 = nav_agent.get_next_path_position()
	sprite_2d.look_at(next_path_position)
	velocity = global_position.direction_to(next_path_position) * GameManager.NPC_SPEED
	move_and_slide()


func on_debug() -> void:
	if GameManager.get_debug():
		debug_label.show()
		nav_agent.debug_enabled = true
	else:
		debug_label.hide()
		nav_agent.debug_enabled = false


func set_labels() -> void:
	var done = "DONE: %s" % nav_agent.is_navigation_finished()
	var reach = "REACH: %s" % nav_agent.is_target_reachable()
	var reached = "REACHED: %s" % nav_agent.is_target_reached()
	var target = "TARGET: %s" % nav_agent.target_position
	
	debug_label.text(1, done)
	debug_label.text(2, reach)
	debug_label.text(3, reached)
	debug_label.text(4, target)
