extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$TextureProgressBar.value = $TextureProgressBar.max_value * Global.charge/100 
	if Input.is_action_just_pressed("Charge"):
		show()
	if Input.is_action_just_released("Charge"):
		hide()
