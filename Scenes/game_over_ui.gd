extends Control
@onready var score_label = $MarginContainer/VBoxContainer/ScoreLabel
@onready var time_label = $MarginContainer/VBoxContainer/TimeLabel
@onready var game_over = $MarginContainer/VBoxContainer/GameOver

var _winner:bool = false
var _elapsed_time:float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	_winner = false
	update_labels()
	SignalManager.on_score_updated.connect(on_score_updated)
	SignalManager.on_level_complete.connect(on_level_complete)
	SignalManager.on_elapsed_time.connect(on_elapsed_time)


func update_labels() -> void:

	score_label.text = "SCORE: %s" % ScoreManager.get_score()
	time_label.text = "TIME: %s" % seconds_to_string()
	if _winner:
		game_over.text = "You beat the game!"
	else:
		game_over.text = "GAME OVER"


func on_score_updated(_v:int):
	update_labels()
	

func on_level_complete(_level):
	_winner = true
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
