extends Area2D

@onready var sprite_2d = $Sprite2D
@onready var sound = $sound
@onready var animation_player = $AnimationPlayer
@onready var collision_shape_2d = $CollisionShape2D

const PILL_1 = preload("res://assets/images/pill1.png")
const PILL_2 = preload("res://assets/images/pill2.png")


var PU_IMAGE = [
	PILL_1,
	PILL_2
]

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_2d.texture = PU_IMAGE.pick_random()
	pass # Replace with function body.



func _on_body_entered(_body):
	SignalManager.on_pickup.emit()
	set_deferred("monitoring", false)
	
	animation_player.play("vanish")
	SoundManager.play_powerup(sound)
	ScoreManager.bonus()

	await get_tree().create_timer(2).timeout
	queue_free()

