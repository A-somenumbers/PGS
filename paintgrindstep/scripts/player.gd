extends CharacterBody2D


const MAX_SPEED = 300
const MIN_SPEED = 20
const BOOST_SPEED = 500
const JUMP_VELOCITY = 300.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera_2d: Camera2D = $Camera2D
@onready var boostfxtimer: Timer = $boostfxtime
@onready var chargeTimer: Timer = $ChargeTime
@onready var coyoteTimer: Timer = $coyote

#for momentum
var groundSpeed := 0
var gravForce := 15
var lms = MAX_SPEED + decel
var acceleration := 16
var decel := 20
var friction := 16
var lastDir: float


#player properties
var boostMeeter := 100.0
var boostDeplet := 0.5
var chargeAdd := 0.1
var airtime = 0.0
var jumps = 0
var normal: Vector2

#states
var isBoosting = false
var charging = false
var charged = false
var isGrinding = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	var direction := Input.get_axis("move_left", "move_right")
	if direction != 0:
		Global.moving = true
	else:
		Global.moving = false
	velocity.x = groundSpeed
	airtime += delta
	if is_on_floor():
		airtime = 0.0
		jumps = 0
		normal = get_floor_normal()
		
		

	if Input.is_action_just_pressed("jump") and jumps<1 and airtime < 0.1:
		velocity += normal * JUMP_VELOCITY
		jumps = 1
		$Audio/jump.play()
		
	else:
		velocity.y += gravForce 
		if(velocity.y >= gravForce*80):
			velocity.y = gravForce*80
	if Input.is_action_pressed("boost") :
		if direction != 0:
			if boostMeeter > 0:	
				boostMeeter -= boostDeplet
			else :
				boostMeeter = 0
		if (boostMeeter > 0):
			isBoosting = true
		else:
			isBoosting = false
	else:
		velocity.x = velocity.move_toward(Vector2.ZERO,decel).x
		isBoosting = false
	#print(groundSpeed)
	var was_on_floor = is_on_floor()
	flash(direction)
	calculateSpeed(direction)
	lastDir = direction
	anim_control(direction)
	cameraControl(direction,camera_2d,delta)
	move_and_slide()
	if(is_on_floor()):
		if(!isGrinding):
			floor_snap_length = 45
	else:
		floor_snap_length = 0
	if was_on_floor and !is_on_floor() and !Input.is_action_just_pressed("jump"):
		coyoteTimer.start()
	if boostMeeter >= 100: boostMeeter = 100
	if Input.is_action_just_pressed("Charge"):
		chargeTimer.start()
		charging = true
	if Input.is_action_just_released("Charge"):
		charging = false
		chargeTimer.stop()
	
	if charging:
		Global.charge = 100 - chargeTimer.time_left / chargeTimer.wait_time * 100
		Global.lastCharge = Global.charge
	else :
		
		Global.charge = 0 
	Global.boost = boostMeeter
	#print(chargeTimer.time_left / chargeTimer.wait_time)
	#print(isGrinding)
	#camera code
	

func _input(event):
	if event.is_action_released("jump"):
		if velocity.y < 0:
			velocity.y *= 0.5
	
	#if event.is_action_released("Charge"):
		#Global.charge = 0.0
		#chargeTimer.stop()
		
		


func anim_control(direction):
	if is_on_floor():
		var normal: Vector2 = get_floor_normal()
		animated_sprite_2d.rotation = normal.angle() + PI/2
		if(isGrinding):
				animated_sprite_2d.play("grind")
		elif direction == 0:
			animated_sprite_2d.play("idle")
		else:
			
			if(abs(groundSpeed) > MAX_SPEED-50):
				animated_sprite_2d.play("faster run")
			elif(abs(groundSpeed)<100):
				animated_sprite_2d.get_sprite_frames().set_animation_speed("run", 6)
				animated_sprite_2d.play("run")
			else:
				animated_sprite_2d.get_sprite_frames().set_animation_speed("run", 12)
				animated_sprite_2d.play("run")
	elif velocity.y <0:
		animated_sprite_2d.play("jump")
		
		
	if direction >0 and !isGrinding:
		animated_sprite_2d.flip_h = false
		
	elif direction <0 and !isGrinding:
		animated_sprite_2d.flip_h = true
		
func flash(direction):
	var flas = boostfxtimer.time_left / boostfxtimer.wait_time
	if(isBoosting and direction != 0):
		
		if boostfxtimer.time_left == 0.0:
			boostfxtimer.start()
		material.set_shader_parameter("flash_modifier",flas)
	else:
		material.set_shader_parameter("flash_modifier",0)
		boostfxtimer.stop()


func calculateSpeed(direction):
	if !isGrinding:	
		if direction < 0:
			
			if groundSpeed > 0 and is_on_floor():
				groundSpeed -= decel
			elif groundSpeed > -lms:
				if is_on_floor():
					groundSpeed -= acceleration/2
				else:
					groundSpeed -= acceleration/4
			if groundSpeed <= -lms and isBoosting == false:
				groundSpeed += acceleration/4

		if direction > 0:
			if groundSpeed <0 and is_on_floor():
				groundSpeed += decel
			elif groundSpeed < MAX_SPEED:
				if is_on_floor():
					groundSpeed += acceleration/2
				else:
					groundSpeed += acceleration/4
			if groundSpeed >= MAX_SPEED and isBoosting == false:
					groundSpeed -= acceleration/4 	
		
	
	if direction == 0 and is_on_floor() and !isGrinding:
		groundSpeed -= min(abs(groundSpeed), friction) * sign(groundSpeed)
	if isBoosting and direction != 0:
		groundSpeed = BOOST_SPEED * direction
	

func cameraControl(direction,Camera2D,delta):
	var fast = 40
	if !isGrinding:
		if isBoosting:
			fast = 80
		else:
			fast = 40
		
		if direction > 0:
			if camera_2d.offset.x < 100:
				camera_2d.offset.x += delta*fast
		if direction < 0:
			if camera_2d.offset.x > -100:
				camera_2d.offset.x -= delta*fast
		if direction == 0:
			if camera_2d.offset.x < 0:
				camera_2d.offset.x += delta*100
			if camera_2d.offset.x > 0:
				camera_2d.offset.x -= delta*100
		if camera_2d.offset.y != 0:
			camera_2d.offset.y = 0




func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.has_method("coin"):
		boostMeeter += 5
	if area.has_method("wall"):
		boostMeeter += 10
	if area.has_method("rail"):
		isGrinding = true
		
func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.has_method("rail"):
		isGrinding = false

		
		
		
func player():
	pass
		
