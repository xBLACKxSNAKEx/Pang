extends Control

func _physics_process(delta):
	if global.ballsList.size() <= 0:
		get_child(global.mode).visible = true;
