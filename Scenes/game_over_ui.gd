extends Control
@onready var score_label = $MarginContainer/VBoxContainer/ScoreLabel
@onready var time_label = $MarginContainer/VBoxContainer/TimeLabel
@onready var game_over = $MarginContainer/VBoxContainer/GameOver
@onready var high_score_label = $MarginContainer/VBoxContainer/HighScoreLabel

var _winner:bool = false
var _elapsed_time:float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	_winner = false
	update_labels()
	SignalManager.on_score_updated.connect(on_score_updated)
	SignalManager.on_level_complete.connect(on_level_complete)
	SignalManager.on_elapsed_time.connect(on_elapsed_time)
	SignalManager.on_high_score_updated.connect(on_high_score_updated)


func _process(delta):
	if Input.is_action_just_pressed("reset_high_score"):
		ScoreManager.reset_high_score()


func update_labels() -> void:

	score_label.text = "SCORE: %s" % ScoreManager.get_score()
	time_label.text = "TIME: %s" % seconds_to_string()
	on_high_score_updated(ScoreManager.get_high_score())
	
	if ScoreManager.used_cheats():
		var x = ScoreManager.used_cheats()
		score_label.text += " (Using Cheats)"
		
	if _winner:
		game_over.text = "You beat level %s\nKeep Going!" % GameManager.get_level()
	else:
		game_over.text = "GAME OVER"


func on_score_updated(_v:int):
	update_labels()
	

func on_level_complete(_level):
	_winner = true
	ScoreManager.time_bonus(_elapsed_time)
	update_labels()


func on_elapsed_time(seconds:float):
	_elapsed_time = seconds
	update_labels()


func seconds_to_string() -> String:
	var elapsed_seconds = int(_elapsed_time)
	
	var seconds = int(elapsed_seconds) % 60
	var minutes = (elapsed_seconds / 60) % 60
	var hours = (elapsed_seconds/ 60) / 60
	
	#returns a string with the format "HH:MM:SS"
	return "%02d:%02d:%02d" % [hours, minutes, seconds]



func on_high_score_updated(score:int):
	high_score_label.text = "High Score: %s" % ScoreManager.get_high_score()
