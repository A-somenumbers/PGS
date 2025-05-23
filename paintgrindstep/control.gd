extends Control

@onready var player: CharacterBody2D = $"../.." 
@export var speed : Label 
@export var meter : Label
func _physics_process(delta: float) -> void:
	speed_label()
	meter_label()
func speed_label():
	speed.text = "Speed: " + str(abs(player.velocity.x))

func meter_label():
	meter.text = "Boost: " + str(round(player.boostMeeter))
