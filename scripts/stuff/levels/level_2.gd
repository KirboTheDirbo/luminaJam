extends Node2D

signal do_dialogue()
@export var spring_spawn:Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	do_dialogue.emit()
	if Global.springSpawn == Vector2.ZERO:
		Global.springSpawn = spring_spawn
	$spring.global_position = Global.springSpawn


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		Global.springSpawn = $spring.global_position
		get_tree().reload_current_scene()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		Global.springSpawn = $spring.global_position
		get_tree().reload_current_scene()


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	Global.springSpawn = Vector2.ZERO
	get_tree().change_scene_to_file("res://scenes/other/level_3.tscn")
