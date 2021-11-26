extends KinematicBody2D

const GRAVITY = 200.0
const WALK_SPEED = 100
const JUMP = 150

var velocity = Vector2()

func _physics_process(delta):
	var jump = false
	velocity.y += delta * GRAVITY
	
	if Input.is_action_pressed("ui_left"):
		velocity.x = -WALK_SPEED
	elif Input.is_action_pressed("ui_right"):
		velocity.x =  WALK_SPEED
	else:
		velocity.x = 0

	move_and_slide(velocity, Vector2(0, -1))
	
	if Input.is_action_pressed("ui_up"):
		if is_on_floor() and not jump:
			velocity.y = -JUMP
			jump = true
	move_and_slide(velocity, Vector2(0, -1), true, 4, 0.785398, true)
	pass
