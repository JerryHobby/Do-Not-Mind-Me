extends CharacterBody2D

class_name Npc

@onready var debug_label = $DebugLabel
@onready var sprite_2d = $Sprite2D
@onready var nav_agent = $NavAgent
@onready var warning = $Warning
@onready var animation_player = $AnimationPlayer

@export var patrol_points:NodePath

@onready var player_detector = $PlayerDetector
@onready var line_2d = $PlayerDetector/Line2D
@onready var ray_cast_2d = $PlayerDetector/RayCast2D
@onready var sound = $sound
@onready var shoot_timer = $ShootTimer

const BULLET = preload("res://Scenes/bullet.tscn")
enum ENEMY_STATE { PATROLLING, CHASING, SEARCHING}

var _first_pass = true

var FOV = {
	ENEMY_STATE.PATROLLING: GameManager.NPC_FOV_PATROLLING,
	ENEMY_STATE.CHASING: GameManager.NPC_FOV_CHASING,
	ENEMY_STATE.SEARCHING: GameManager.NPC_FOV_SEARCHING
}

var SPEED = {
	ENEMY_STATE.PATROLLING: GameManager.NPC_SPEED_PATROLLING,
	ENEMY_STATE.CHASING: GameManager.NPC_SPEED_CHASING,
	ENEMY_STATE.SEARCHING: GameManager.NPC_SPEED_SEARCHING
}

var SIGHT_RANGE = {
	ENEMY_STATE.PATROLLING: GameManager.NPC_SIGHT_RANGE_PATROLLING,
	ENEMY_STATE.CHASING: GameManager.NPC_SIGHT_RANGE_CHASING,
	ENEMY_STATE.SEARCHING: GameManager.NPC_SIGHT_RANGE_SEARCHING
}

var BEAM_COLOR = {
	ENEMY_STATE.PATROLLING: Color(1, 1, 1, 0.25),
	ENEMY_STATE.CHASING: Color(1, 0, 0, .25),
	ENEMY_STATE.SEARCHING:  Color(1, .5, 0, 0.5)
}

var _waypoints:Array = []
var _current_waypoint:int = 0
var _player_ref:Player
var _state:ENEMY_STATE = ENEMY_STATE.PATROLLING


func _ready():
	set_physics_process(false)
	call_deferred("create_waypoints")

	shoot_timer.wait_time = GameManager.NPC_SHOOT_DELAY
	shoot_timer.start()
	_player_ref = get_tree().get_first_node_in_group(GameManager.GROUP_PLAYER)

	SignalManager.on_debug.connect(on_debug)
	call_deferred("on_debug")
	call_deferred("set_physics_process", true)


func set_target_range(v:float) -> void:
	ray_cast_2d.target_position.y = v
	line_2d.points[1].y = v


func _physics_process(_delta):
	
	if Input.is_action_pressed("set_target"):
		set_state(ENEMY_STATE.CHASING)
	
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

	#if nav_agent.distance_to_target() < 50:
		#if GameManager.get_god_mode() == false:
			#SignalManager.on_player_died.emit()

	if nav_agent.distance_to_target() < 100:
		nav_agent.target_position = global_position


func alert(new_state) -> void:
	
	if new_state == ENEMY_STATE.CHASING:
		if _state == ENEMY_STATE.PATROLLING:
			SoundManager.play_gasp(sound)
			
		animation_player.play("alert")
		warning.show()

	elif new_state == ENEMY_STATE.SEARCHING:
		animation_player.play("RESET")
		warning.show()

	elif new_state == ENEMY_STATE.PATROLLING:
		animation_player.play("RESET")
		warning.hide()


func update_movement() -> void:
	line_2d.default_color = BEAM_COLOR[_state]
	match _state:
		ENEMY_STATE.PATROLLING:
			process_patrolling()
		ENEMY_STATE.CHASING:
			process_chasing()
		ENEMY_STATE.SEARCHING:
			process_searching()

	
func process_patrolling() -> void:
	if nav_agent.is_navigation_finished():
		navigate_to_waypoint()


func process_chasing() -> void:
	set_nav_to_player()


func process_searching() -> void:
	if nav_agent.is_navigation_finished():
		set_state(ENEMY_STATE.PATROLLING)


func set_state(new_state:ENEMY_STATE) -> void:
	if new_state == _state:
		return
	
	alert(new_state)
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
	set_target_range(SIGHT_RANGE[_state]) 
	var c = ray_cast_2d.get_collider()
	var distance:float = global_transform.origin.distance_to(
			ray_cast_2d.get_collision_point())
	
	# default range
	line_2d.points[1].y = ray_cast_2d.target_position.y

	if c == null:
		return false
	elif c.is_in_group(GameManager.GROUP_PLAYER) \
	and player_in_fov():
		line_2d.points[1].y = distance + 20
		return true
	else:
		line_2d.points[1].y = distance
		return false


func player_in_fov() -> bool:
	if get_fov_angle() <= FOV[_state]:
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
	if _first_pass:
		await get_tree().process_frame
		_first_pass = false
	
	if nav_agent.is_navigation_finished():
		return
		
	var next_path_position:Vector2 = nav_agent.get_next_path_position()
	sprite_2d.look_at(next_path_position)
	velocity = global_position.direction_to(next_path_position) * SPEED[_state]

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
	if _first_pass:
		await get_tree().process_frame

	#var done = "DONE: %s" % nav_agent.is_navigation_finished()
	var reach = "REACH: %s" % nav_agent.is_target_reachable()
	var reached = "REACHED: %s" % nav_agent.is_target_reached()
	#var target = "TARGET: %s" % nav_agent.target_position
	var fov = "fov: %.2f" % get_fov_angle()
	var state = "state: %s" % ENEMY_STATE.find_key(_state)
	
	debug_label.text(1, state)
	debug_label.text(2, reach)
	debug_label.text(3, reached)
	debug_label.text(4, fov)


func shoot() -> void:
	var target = _player_ref.global_position
	
	var bullet = BULLET.instantiate()
	bullet.setup(target, global_position)
	get_tree().root.add_child(bullet)
	SoundManager.play_laser(sound)


func _on_shoot_timer_timeout():
	if _state != ENEMY_STATE.CHASING:
		return
	
	shoot()
