extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	
	if has_overlapping_bodies():
		pass

func rail():
	pass
