extends Area2D

@onready var timer: Timer = $Timer


func _on_body_entered(body):
	print("dead :p")
	Engine.time_scale = 0.5
	body.get_node("CollisionShape2D").queue_free()
	Global.score = 0
	timer.start()
	


func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()
	
