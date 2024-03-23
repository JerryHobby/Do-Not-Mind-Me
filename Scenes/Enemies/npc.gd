extends CharacterBody2D
@onready var debug_label = $DebugLabel


func _ready():
	SignalManager.on_debug.connect(on_debug)
	debug_label.text(1, "line 1 text here")
	debug_label.text(2, "line 2 text here")
	debug_label.text(3, "line 3")
	debug_label.text(4, "text for line 4")

func _process(delta):
	pass


func on_debug() -> void:
	if GameManager.get_debug():
		debug_label.show()
	else:
		debug_label.hide()

