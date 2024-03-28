extends AnimatedSprite2D
@onready var sound = $Sound


# Called when the node enters the scene tree for the first time.
func _ready():
	SoundManager.play_boom(sound)


func _on_animation_finished():
	queue_free()
