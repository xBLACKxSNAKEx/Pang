extends Control

export(int) var mode = 0;

func _ready():
	visible = false;
	pass

func _unhandled_input(event):
	if mode == 1 and global.mode == 1:
		if event is InputEventKey:
			if global.player.lifes_left > 0:
				if event.pressed and event.scancode == KEY_ESCAPE:
					if visible:
						unpause()
					else:
						pause()
	elif mode != 1 and global.mode != 1:
		if event is InputEventKey:
			if global.player.lifes_left > 0:
				if event.pressed and event.scancode == KEY_ESCAPE:
					if visible:
						unpause()
					else:
						pause()
	pass

func save():
	global.save();
	pass

func exit():
	get_tree().change_scene("res://Start.tscn");
	get_tree().paused = false;
	global.ballsList.clear();
	global.save = "";
	pass

func pause():
	visible = true;
	get_tree().paused = true
	pass

func unpause():
	visible = false;
	get_tree().paused = false
	pass
