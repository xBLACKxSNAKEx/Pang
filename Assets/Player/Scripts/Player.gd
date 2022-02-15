extends KinematicBody2D

const GRAVITY = 200.0
const WALK_SPEED = 100
const JUMP = 150

const INVINCIBILITY_TIME = 1.5

var lifes_left = 5

var velocity = Vector2()
var last_death = OS.get_ticks_msec()

var click = 0

func setLifes(lifes):
	lifes_left = lifes
pass

func _physics_process(delta):
	var jump = false
	velocity.y += delta * GRAVITY
	
	if Input.is_action_pressed("ui_left"):
		velocity.x = -WALK_SPEED
	elif Input.is_action_pressed("ui_right"):
		velocity.x =  WALK_SPEED
	else:
		velocity.x = 0

	var _a = move_and_slide(velocity, Vector2(0, -1))
	
	if OS.get_ticks_msec() - last_death <= INVINCIBILITY_TIME * 1000:
		if OS.get_ticks_msec() - click > 150:
			click = OS.get_ticks_msec()
			get_child(1).modulate.a = -get_child(1).modulate.a
	else:
		get_child(1).modulate.a = 1
	
	if Input.is_action_pressed("ui_up"):
		if is_on_floor():
			if not jump:
				velocity.y = -JUMP
				jump = true
		else:
			jump = false
	_a = move_and_slide(velocity, Vector2(0, -1), true, 4, 0.785398, true)
	pass


func _on_Area2D_body_entered(body):
	if body.get_collision_layer_bit(2):
		if OS.get_ticks_msec() - last_death > INVINCIBILITY_TIME * 1000:
			last_death = OS.get_ticks_msec()
			lifes_left-=1
			print(lifes_left)
			if lifes_left <= 0:
				get_tree().paused = true
	pass # Replace with function body.
