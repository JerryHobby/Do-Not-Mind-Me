extends Area2D
var boom_scene:PackedScene = preload("res://Scenes/boom.tscn")

var _direction_of_travel:Vector2 = Vector2.ZERO
var _target_position:Vector2 = Vector2.ZERO
@onready var timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	look_at(_target_position)


func setup(target:Vector2, start_pos:Vector2):
	_target_position = target
	_direction_of_travel = start_pos.direction_to(target)
	global_position = start_pos


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += GameManager.NPC_BULLET_SPEED * delta * _direction_of_travel


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

