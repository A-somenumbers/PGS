extends Control


# Called when the node enters the scene tree for the first time.


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/hub_world.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
