extends Control

@onready var player: CharacterBody2D = $"../.." 
@export var speed : Label 
@export var charge : Label
@export var meter2 : ProgressBar
func _physics_process(delta: float) -> void:
	speed_label()
	meter_label()
func speed_label():
	speed.text = "Speed: " + str(abs(player.velocity.x))

func meter_label():
	meter2.value = round(player.boostMeeter)
	charge.text = "Meter: " + str(abs(player.chargeMeter))
