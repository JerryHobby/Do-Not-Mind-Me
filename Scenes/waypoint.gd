extends Marker2D
@onready var sprite_2d = $Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.on_debug.connect(on_debug)
	on_debug()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func on_debug() -> void:
	if GameManager.get_debug():
		sprite_2d.show()
	else:
		sprite_2d.hide()
