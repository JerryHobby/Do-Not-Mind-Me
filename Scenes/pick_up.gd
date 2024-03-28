extends Area2D

@onready var sound = $sound
@onready var animation_player = $AnimationPlayer
@onready var animated_sprite_2d = $AnimatedSprite2D

const PILL_1 = preload("res://assets/images/pill1.png")
const PILL_2 = preload("res://assets/images/pill2.png")


var PU_IMAGE = [
	PILL_1,
	PILL_2
]

# Called when the node enters the scene tree for the first time.
func _ready():
	var frame_count = animated_sprite_2d.sprite_frames.get_frame_count(animated_sprite_2d.animation)
	animated_sprite_2d.frame = randi_range(0, frame_count)


func _on_body_entered(_body):
	SignalManager.on_pickup.emit()
	set_deferred("monitoring", false)
	
	animation_player.play("vanish")
	SoundManager.play_powerup(sound)
	ScoreManager.bonus()

	await get_tree().create_timer(2).timeout
	queue_free()

