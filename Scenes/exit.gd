extends Area2D
@onready var sound = $Sound

@export var level:int = 1


func _on_body_entered(_body):
	ScoreManager.level(level)
	hide()
	SoundManager.play_win(sound)
	GameManager.set_pause(true)
	await get_tree().create_timer(1.5).timeout
	SignalManager.on_level_complete.emit(level)
	queue_free()

