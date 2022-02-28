extends Control

func _physics_process(delta):
	if global.player.lifes_left <= 0:
		visible = true;
