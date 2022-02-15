extends Button

var mapID = -1;

func _on_Map1_button_down():
	global.map = mapID;
	global.play();
	pass
