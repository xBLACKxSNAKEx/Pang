extends AudioStreamPlayer

var x = false;

func _physics_process(delta):
	if playing == false:
		if x:
			queue_free();
	else:
		x = true;
	pass
