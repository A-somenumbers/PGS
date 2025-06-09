extends Camera2D

@export var randStrength: float = 30.0
@export var ShakeFade = 5.0
@onready var player: CharacterBody2D = $".."

var rng = RandomNumberGenerator.new()
var strength = 0.0

	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("boost") and Global.boost > 0 and Global.moving:
		strength = randStrength
	if Input.is_action_just_released("Charge") and Global.lastCharge == 100:
		strength = randStrength/10

	
	if strength>0:
		strength = lerpf(strength,0,ShakeFade*delta)
		offset.x += randOff().x
		offset.y = randOff().y
	


func randOff():
	return Vector2(rng.randf_range(-strength,strength),rng.randf_range(-strength,strength))
