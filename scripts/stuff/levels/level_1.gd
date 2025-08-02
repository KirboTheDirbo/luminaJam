extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#subject to change
	if Global.springSpawn == Vector2.ZERO:
		Global.springSpawn = Vector2(543.0,264.0)
	$spring.global_position = Global.springSpawn


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		Global.springSpawn = $spring.global_position
		get_tree().reload_current_scene()
