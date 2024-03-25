extends CharacterBody2D

class_name Npc

@onready var debug_label = $DebugLabel
@onready var sprite_2d = $Sprite2D
@onready var nav_agent = $NavAgent

@export var patrol_points:NodePath
@onready var player_detector = $PlayerDetector
@onready var line_2d = $PlayerDetector/Line2D
@onready var ray_cast_2d = $PlayerDetector/RayCast2D


var _waypoints:Array = []
var _current_waypoint:int = 0
var _player_ref:Player

const COLOR_NOTHING_SEEN = Color(1, 1, 1, 0.25)
const COLOR_PLAYER_SEEN = Color(1, 0, 0, 0.25)
const COLOR_WALL_SEEN = Color(0, 0, 1, 0.25)

func _ready():
	set_physics_process(false)
	set_target_range()
	create_waypoints()
	_player_ref = get_tree().get_first_node_in_group(GameManager.GROUP_PLAYER)
	call_deferred("set_physics_process", true)
	SignalManager.on_debug.connect(on_debug)

	on_debug()


func set_target_range() -> void:
	ray_cast_2d.target_position.y = GameManager.NPC_SIGHT_RANGE
	line_2d.points[1].y = ray_cast_2d.target_position.y


func _physics_process(_delta):	
	if Input.is_action_pressed("set_target"):
		nav_agent.target_position = get_global_mouse_position()
		
	update_navigation()
	raycast_to_player()
	player_detected()
	process_patrolling()
	set_labels()


func create_waypoints() -> void:
	for pp in get_node(patrol_points).get_children():
		_waypoints.append(pp.global_position)


func raycast_to_player() -> void:
	player_detector.look_at(_player_ref.global_position)


func player_detected() -> bool:
	var c = ray_cast_2d.get_collider()
	var distance:int = global_transform.origin.distance_to(
			ray_cast_2d.get_collision_point())
	
	# default range
	line_2d.points[1].y = ray_cast_2d.target_position.y
	
	if c == null:
		line_2d.default_color = COLOR_NOTHING_SEEN
		return false
	elif c.is_in_group(GameManager.GROUP_PLAYER):
		line_2d.points[1].y = distance + 20
		line_2d.default_color = COLOR_PLAYER_SEEN
		return true
	else:
		line_2d.points[1].y = distance
		line_2d.default_color = COLOR_WALL_SEEN
		return false


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
		line_2d.show()
		nav_agent.debug_enabled = true

	else:
		debug_label.hide()
		line_2d.hide()
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

