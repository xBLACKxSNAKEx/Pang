extends RigidBody2D

var d = 4

onready var start_time = OS.get_ticks_msec()

var A = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var i = 0

func _physics_process(delta):
	var v = sqrt(linear_velocity.x*linear_velocity.x + linear_velocity.y*linear_velocity.y)
	if v > A:
		var normalized = Vector2(linear_velocity.x / v, linear_velocity.y/v)
		apply_central_impulse(-normalized*10)
	pass

func _on_Area2D_body_entered(body):
	if body.get_collision_layer_bit(4):
		if d == 0:
			queue_free()
		else:
			split()
	pass # Replace with function body.

func split():
	d-=1
	var dup = duplicate()
	dup.d = d
	var Map_Object = get_parent()
	Map_Object.add_child(dup)
	apply_impulse(Vector2(0,0), Vector2(100, 0))
	dup.apply_impulse(Vector2(0,0), Vector2(-100, 0))
	pass
