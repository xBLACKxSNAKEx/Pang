extends RigidBody2D

var d = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var i = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func split():
	d-=1
	var dup = duplicate()
	
	get_parent().add_child(dup)
	apply_impulse(Vector2(0,0), Vector2(100, 0))
	dup.apply_impulse(Vector2(0,0), Vector2(-100, 0))
	dup.d = d
	pass
