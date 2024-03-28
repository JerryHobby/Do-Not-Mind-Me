extends CanvasLayer

@onready var score_label = $MarginContainer/HBoxContainer/ScoreLabel
@onready var pickups_label = $MarginContainer/HBoxContainer/PickupsLabel
@onready var time_label = $MarginContainer/HBoxContainer/TimeLabel

var _elapsed_time:float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	on_score_updated(ScoreManager.get_score())
	SignalManager.on_score_updated.connect(on_score_updated)
	SignalManager.on_elapsed_time.connect(on_elapsed_time)


func on_pickup_update(remaining:int) -> void:
	if remaining:
		pickups_label.text = "Remaining Bonuses: %s" % remaining
	else:
		pickups_label.text = "Find the exit"


func on_score_updated(score:int) -> void:
	score_label.text = "Score: %s" % score


func on_elapsed_time(seconds:float) -> void:
	_elapsed_time = seconds
	time_label.text = "Time: %s" % seconds_to_string()


func seconds_to_string() -> String:
	var elapsed_seconds = int(_elapsed_time)
	
	var seconds:int = int(elapsed_seconds) % 60
	var minutes:int = int((elapsed_seconds / 60) % 60)
	var hours:int = int(elapsed_seconds/ 60) / 60
	
	#returns a string with the format "HH:MM:SS"
	return "%02d:%02d:%02d" % [hours, minutes, seconds]
