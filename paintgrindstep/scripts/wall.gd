extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	
	if has_overlapping_bodies():
		
		if Global.lastCharge >= 100:
			if Input.is_action_just_released("Charge"):
				animated_sprite_2d.play("scribbled")
				Global.score += 100
				


#func _on_body_entered(body: Node2D) -> void:
	#if Input.is_action_pressed("Charge"):
		#animated_sprite_2d.play("scribbled")

func wall():
	pass
