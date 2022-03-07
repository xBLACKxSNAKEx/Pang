extends Control

var lifes = 0;

func _ready():
	lifes = 0;
	pass

func _process(delta):
	if global.player.lifesLeft != lifes:
		for i in range(0,6):
			get_child(i).visible = false;
		for i in range(0, global.player.lifesLeft):
			if i <= get_child_count() and i >= 0:
				get_child(i).visible = true;
		lifes = global.player.lifesLeft;
	pass
