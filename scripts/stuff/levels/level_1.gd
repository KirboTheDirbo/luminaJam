extends Node2D

signal do_dialogue()

func _ready() -> void:
	do_dialogue.emit()
	#subject to change
	if Global.springSpawn == Vector2.ZERO:
		Global.springSpawn = Vector2(543.0,264.0)
	$spring.global_position = Global.springSpawn


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		Global.springSpawn = $spring.global_position
		get_tree().reload_current_scene()
