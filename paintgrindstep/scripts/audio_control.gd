extends Node


# Called when the node enters the scene tree for the first time.
# Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_amen_break_finished() -> void:
	$AmenBreak.play()
