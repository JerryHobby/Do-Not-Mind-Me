extends Node2D
@onready var high_score = $CanvasLayer/VBoxContainer/HighScore


# Called when the node enters the scene tree for the first time.
func _ready():
	high_score.text = "High Score: %s" % ScoreManager.get_high_score()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("fire"):
		get_tree().change_scene_to_packed(GameManager.LEVEL_SCENE)
