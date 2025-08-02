extends RigidBody2D
signal bounced



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("defulat")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		emit_signal("bounced")
