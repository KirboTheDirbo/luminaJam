extends Node2D
signal do_dialogue()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	do_dialogue.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://scenes/levels/victory.tscn")


func _on_area_2d_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
