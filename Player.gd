extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 600
const MAXFALLSPEED = 200
const MAXSPEED = 80
const JUMPFORCE = 400	
const ACCEL = 300
const FRICTION = 1
const AIRRESIST = 0.02

var motion = Vector2()

func _physics_process(delta):
	var x_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	


	motion.y += GRAVITY * delta
	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED

	if x_input != 0:
		motion.x += x_input * ACCEL * delta
		motion.x = clamp(motion.x, -MAXSPEED,MAXSPEED)
		$AnimatedSprite.flip_h = motion.x < 0
		
	if is_on_floor():
		if x_input != 0:
			$AnimatedSprite.play("walk")
		if x_input == 0: 
			$AnimatedSprite.play("idle")
			motion.x = lerp(motion.x, 0,FRICTION)
		if Input.is_action_just_pressed("jump"):
			motion.y = -JUMPFORCE
	else:
		if Input.is_action_just_released("jump") and motion.y < -JUMPFORCE/2:
			motion.y = -JUMPFORCE/2
		if x_input == 0:
			motion.x = lerp(motion.x, 0,AIRRESIST)
		if motion.y < 0:
			$AnimatedSprite.play("jump")
		elif motion.y > 0:
			$AnimatedSprite.play("fall")
	
	motion = move_and_slide(motion,Vector2.UP)
