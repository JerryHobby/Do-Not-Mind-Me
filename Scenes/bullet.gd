extends Area2D
var boom_scene:PackedScene = preload("res://Scenes/boom.tscn")

var _direction_of_travel:Vector2 = Vector2.ZERO
var _target_position:Vector2 = Vector2.ZERO
@onready var timer = $Timer

var _speed:float = GameManager.NPC_BULLET_SPEED



func _ready():
	adjust_game_speed()
	look_at(_target_position)


func setup(target:Vector2, start_pos:Vector2):
	_target_position = target
	_direction_of_travel = start_pos.direction_to(target)
	global_position = start_pos



func adjust_game_speed() -> void:
	var level =  GameManager.get_level() - 1
	var boost = GameManager.LEVEL_DIFFICULTY_BOOST * level

	_speed *= (1 + boost)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += _speed * delta * _direction_of_travel


func _on_body_entered(_body):
	create_boom()
	if _body.is_in_group("player"):
		SignalManager.on_player_died.emit()


func create_boom() -> void:
	var boom = boom_scene.instantiate()

	boom.global_position = global_position
	get_tree().root.add_child(boom)
	queue_free()


func _on_timer_timeout():
	#create_boom()
	pass

