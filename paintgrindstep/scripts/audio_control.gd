extends Node


# Called when the node enters the scene tree for the first time.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_released("Charge") and Global.lastCharge == 100:
		$AmenBreak.play(1.7)
