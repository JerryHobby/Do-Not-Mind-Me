extends CanvasLayer

@onready var score_label = $MarginContainer/HBoxContainer/ScoreLabel
@onready var pickups_label = $MarginContainer/HBoxContainer/PickupsLabel

var _pickups_total:int

# Called when the node enters the scene tree for the first time.
func _ready():
	_pickups_total = get_tree().get_nodes_in_group(GameManager.GROUP_PICKUP).size()
	on_pickup(_pickups_total)
	on_score_updated(0)
	SignalManager.on_pickup.connect(on_pickup)
	SignalManager.on_score_updated.connect(on_score_updated)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func on_pickup(remaining:int) -> void:
	if remaining:
		pickups_label.text = "Remaining Bonuses: %s" % remaining
	else:
		pickups_label.text = "Find the exit"


func on_score_updated(score:int) -> void:
	score_label.text = "Score: %s" % score
