extends Control

func _ready() -> void:
	$AnimationPlayer.play("RESET")

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("new_animation")

func pause():
	get_tree().paused = true
	$AnimationPlayer.play("new_animation")

func pausing():
	if Input.is_action_just_pressed("Pause") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("Pause") and get_tree().paused:
		resume()	



func _on_resume_pressed() -> void:
	resume()



func _on_restart_pressed() -> void:
	resume()
	get_tree().reload_current_scene()
	
	



func _on_quit_pressed() -> void:
	get_tree().quit()

func _physics_process(delta: float) -> void:
	pausing()
