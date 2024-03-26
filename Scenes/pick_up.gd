extends Area2D

const PILL_1 = preload("res://assets/images/pill1.png")
const PILL_2 = preload("res://assets/images/pill2.png")
@onready var sprite_2d = $Sprite2D
@onready var sound = $sound

var PU_IMAGE = [
	PILL_1,
	PILL_2
]

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_2d.texture = PU_IMAGE.pick_random()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	pickup()
	hide()

	await get_tree().create_timer(0.5).timeout
	SignalManager.on_pickup.emit(get_tree().get_nodes_in_group(GameManager.GROUP_PICKUP).size()-1)
	queue_free()

func pickup() -> void:
	SoundManager.play_powerup(sound)
	ScoreManager.bonus()

