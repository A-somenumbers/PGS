extends Control

@onready var player: CharacterBody2D = $"../.." 
@export var speed : Label 
@export var score : Label
@export var meter2 : ProgressBar
var time_in_mill = 0

func _physics_process(delta: float) -> void:
	speed_label()
	meter_label()
func speed_label():
	score.text = "Score: " + str(Global.score)

func meter_label():
	meter2.value = round(player.boostMeeter)

func _on_timer_timeout() -> void:
	time_in_mill += 1
	var s = int(time_in_mill/100)
	var m = int(s/60)
	var ms = time_in_mill - s * 100
	speed.text = '%02d:%02d:%02d' % [m,s,ms]
