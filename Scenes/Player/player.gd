extends CharacterBody2D

class_name Player

@onready var camera_2d = $"../Camera2D"
@onready var sound = $sound
@onready var animated_sprite_2d = $AnimatedSprite2D

var _speed = GameManager.PLAYER_SPEED

func _ready():
	adjust_game_speed()
	

func adjust_game_speed() -> void:
	var level =  GameManager.get_level() - 1
	var boost = GameManager.LEVEL_DIFFICULTY_BOOST * level

	_speed *= (1 + (boost * 0.8))


func _physics_process(_delta):
	get_input()
	move_and_slide()
	if velocity:
		rotation = velocity.angle()
	camera_2d.global_position = global_position


func get_input():
	var new_velocity = Vector2.ZERO
	
	new_velocity.x = Input.get_action_strength("right") \
	- Input.get_action_strength("left")
	
	new_velocity.y = Input.get_action_strength("down") \
	 - Input.get_action_strength("up")
	
	if velocity == Vector2.ZERO:
		animated_sprite_2d.speed_scale = 0
		animated_sprite_2d.frame = 1
	else:
		animated_sprite_2d.speed_scale = 1

	velocity = new_velocity.normalized() * _speed
