extends AnimatableBody2D



func rail():
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		print("rail")
