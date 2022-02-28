extends CPUParticles2D

var x = false;

func _physics_process(delta):
	if emitting == false:
		if x:
			queue_free()
	else:
		x = true;
	pass
	
