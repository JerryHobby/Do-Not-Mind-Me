extends Node2D
@onready var debug_label_1 = $ColorRect/HBoxContainer/DebugLabel1
@onready var debug_label_2 = $ColorRect/HBoxContainer/DebugLabel2
@onready var debug_label_3 = $ColorRect/HBoxContainer/DebugLabel3
@onready var debug_label_4 = $ColorRect/HBoxContainer/DebugLabel4



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func text(line:int, value:String) -> void:
	match line:
		1:
			debug_label_1.text = value
		2:
			debug_label_2.text = value
		3:
			debug_label_3.text = value
		4:
			debug_label_4.text = value
