extends CharacterBody2D

class_name Npc

@onready var debug_label = $DebugLabel
@onready var sprite_2d = $Sprite2D
@onready var nav_agent = $NavAgent
@onready var warning = $Warning

@export var patrol_points:NodePath
@onready var player_detector = $PlayerDetector
@onready var line_2d = $PlayerDetector/Line2D
@onready var ray_cast_2d = $PlayerDetector/RayCast2D

const COLOR_NOTHING_SEEN = Color(1, 1, 1, 0.25)
const COLOR_PLAYER_SEEN = Color(1, 0, 0, 0.25)
const COLOR_WALL_SEEN = Color(0, 0, 1, 0.25)

enum ENEMY_STATE { PATROLLING, CHASING, SEARCHING}


var _waypoints:Array = []
var _current_waypoint:int = 0
var _player_ref:Player
var _speed = GameManager.NPC_SPEED_WALK
var _fov = GameManager.NPC_FOV_WALK
var _state:ENEMY_STATE = ENEMY_STATE.PATROLLING


func _ready():
	set_physics_process(false)
	set_target_range(GameManager.NPC_SIGHT_RANGE_WALK)
	create_waypoints()
	_player_ref = get_tree().get_first_node_in_group(GameManager.GROUP_PLAYER)
	call_deferred("set_physics_process", true)
	SignalManager.on_debug.connect(on_debug)

	on_debug()


func set_target_range(v:float) -> void:
	ray_cast_2d.target_position.y = v
	line_2d.points[1].y = v


func _physics_process(_delta):	
	if Input.is_action_pressed("set_target"):
		set_state(ENEMY_STATE.CHASING)
		
	update_navigation()
	raycast_to_player()
	update_state()
	update_movement()
	update_navigation()
	set_labels()


func create_waypoints() -> void:
	for pp in get_node(patrol_points).get_children():
		_waypoints.append(pp.global_position)


func raycast_to_player() -> void:
	player_detector.look_at(_player_ref.global_position)


func set_nav_to_player() -> void:
	nav_agent.target_position = _player_ref.global_position


func update_movement() -> void:
	match _state:
		ENEMY_STATE.PATROLLING:
			process_patrolling()
		ENEMY_STATE.CHASING:
			process_chasing()
		ENEMY_STATE.SEARCHING:
			process_searching()


func set_alert(alert:bool) -> void:
	if alert:
		_speed = GameManager.NPC_SPEED_RUN
		_fov = GameManager.NPC_FOV_RUN
		set_target_range(GameManager.NPC_SIGHT_RANGE_RUN) 
		warning.show()
	else:
		_speed = GameManager.NPC_SPEED_WALK
		_fov = GameManager.NPC_FOV_WALK
		warning.hide()
		set_target_range(GameManager.NPC_SIGHT_RANGE_WALK) 
	
	
func process_patrolling() -> void:
	set_alert(false)
	if nav_agent.is_navigation_finished():
		navigate_to_waypoint()


func process_chasing() -> void:
	set_alert(true)
	set_nav_to_player()


func process_searching() -> void:
	set_alert(true)
	if nav_agent.is_navigation_finished():
		set_state(ENEMY_STATE.PATROLLING)


func set_state(new_state:ENEMY_STATE) -> void:
	if new_state == _state:
		return

	_state = new_state

	
func update_state() -> void:
	var new_state = _state
	var can_see = can_see_player()
	
	if can_see:
		new_state = ENEMY_STATE.CHASING
	elif can_see == false and _state == ENEMY_STATE.CHASING:
		new_state = ENEMY_STATE.SEARCHING

	set_state(new_state)







func can_see_player() -> bool:
	var c = ray_cast_2d.get_collider()
	var distance:int = global_transform.origin.distance_to(
			ray_cast_2d.get_collision_point())
	
	# default range
	line_2d.points[1].y = ray_cast_2d.target_position.y
	
	if c == null:
		line_2d.default_color = COLOR_NOTHING_SEEN
		return false
	elif c.is_in_group(GameManager.GROUP_PLAYER) \
	and player_in_fov():
		line_2d.points[1].y = distance + 20
		line_2d.default_color = COLOR_PLAYER_SEEN
		return true
	else:
		line_2d.points[1].y = distance
		line_2d.default_color = COLOR_WALL_SEEN
		return false


func player_in_fov() -> bool:
	if get_fov_angle() <= _fov:
		return true
	return false


func get_fov_angle() -> float:
	var direction = global_position.direction_to(_player_ref.global_position)
	var dot_p = direction.dot(velocity.normalized())
	if dot_p >= -1.0 and dot_p <= 1.0:
		return rad_to_deg(acos(dot_p))
	return 0.0


func navigate_to_waypoint() -> void:
	if _current_waypoint >= len(_waypoints):
		_current_waypoint = 0

	nav_agent.target_position = _waypoints[_current_waypoint]
	_current_waypoint += 1


func update_navigation() -> void:
	if nav_agent.is_navigation_finished():
		return
		
	var next_path_position:Vector2 = nav_agent.get_next_path_position()
	sprite_2d.look_at(next_path_position)
	velocity = global_position.direction_to(next_path_position) * _speed

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
	var fov = "fov: %.2f" % get_fov_angle()
	var state = "state: %s" % ENEMY_STATE.find_key(_state)
	
	debug_label.text(1, state)
	debug_label.text(2, reach)
	debug_label.text(3, reached)
	debug_label.text(4, fov)

