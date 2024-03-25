extends CharacterBody2D
@onready var debug_label = $DebugLabel
@onready var sprite_2d = $Sprite2D
@onready var nav_agent = $NavAgent

@export var patrol_points:NodePath

var _waypoints:Array = []
var _current_waypoint:int = 0


func _ready():
	set_physics_process(false)
	create_waypoints()
	call_deferred("set_physics_process", true)
	SignalManager.on_debug.connect(on_debug)
	on_debug()


func _physics_process(_delta):	
	if Input.is_action_pressed("set_target"):
		nav_agent.target_position = get_global_mouse_position()
		
	update_navigation()
	process_patrolling()
	set_labels()


func create_waypoints() -> void:
	for pp in get_node(patrol_points).get_children():
		_waypoints.append(pp.global_position)



func navigate_to_waypoint() -> void:
	if _current_waypoint >= len(_waypoints):
		_current_waypoint = 0

	nav_agent.target_position = _waypoints[_current_waypoint]
	_current_waypoint += 1


func process_patrolling() -> void:
	if nav_agent.is_navigation_finished():
		navigate_to_waypoint()


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
