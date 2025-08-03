extends Node2D

signal do_dialogue()

@export var springSpawn:Vector2
@onready var spring = $spring

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	do_dialogue.emit()
	if Global.springSpawn == Vector2.ZERO:
		Global.springSpawn = springSpawn
	spring.global_position = Global.springSpawn
	print(Global.springSpawn)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		Global.springSpawn = spring.global_position
		get_tree().reload_current_scene()


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://scenes/levels/finale.tscn")
