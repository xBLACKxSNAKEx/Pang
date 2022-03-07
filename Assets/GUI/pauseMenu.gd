extends Control

export(int) var mode = 0;

func _ready():
	visible = false;
	pass

func _unhandled_input(event):
	if mode == 1 and global.mode == 1:
		if event is InputEventKey:
			if global.player.lifesLeft > 0:
				if event.pressed and event.scancode == KEY_ESCAPE:
					if visible:
						unpause()
					else:
						pause()
	elif mode != 1 and global.mode != 1:
		if event is InputEventKey:
			if global.player.lifesLeft > 0:
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
	unpause()
	global.ballsList.clear();
	global.save = "";
	get_tree().change_scene("res://Start.tscn");
	pass

func pause():
	visible = true;
	get_tree().paused = true
	pass

func unpause():
	visible = false;
	get_tree().paused = false
	pass

func _on_Option_button_down():
	get_parent().get_node("OptionsMenu").visible = true;
	pass

func _on_BackOptBtn_button_down():
	get_parent().get_node("OptionsMenu").visible = false;
	pass
