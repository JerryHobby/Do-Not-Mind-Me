extends Node2D
@onready var high_score = $CanvasLayer/VBoxContainer/HighScore


# Called when the node enters the scene tree for the first time.
func _ready():
	on_high_score_updated(ScoreManager.get_high_score())
	ScoreManager.reset()
	SignalManager.on_high_score_updated.connect(on_high_score_updated)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("fire"):
		get_tree().change_scene_to_packed(GameManager.LEVEL_SCENE)
		
	if Input.is_action_just_pressed("reset_high_score"):
		ScoreManager.reset_high_score()


func on_high_score_updated(score:int):
	high_score.text = "High Score: %s" % ScoreManager.get_high_score()
