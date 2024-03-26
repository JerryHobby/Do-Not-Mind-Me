extends CharacterBody2D

class_name Player

@onready var camera_2d = $"../Camera2D"
@onready var sound = $sound



func _ready():
	pass


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
	
	velocity = new_velocity.normalized() * GameManager.PLAYER_SPEED * 2
	
