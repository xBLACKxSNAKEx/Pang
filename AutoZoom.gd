extends Camera2D

export(int) var viewSizeX = 1024;
export(int) var viewSizeY = 600;

func _ready():
	get_tree().get_root().connect("size_changed", self, "auto_zoom");
	var size = get_viewport_rect().size;
	zoom.y = 1/(size.y / viewSizeY);
	zoom.x = 1/(size.x / viewSizeX);
	pass

func auto_zoom():	
	var size = get_viewport_rect().size;
	zoom.y = 1/(size.y / viewSizeY);
	zoom.x = 1/(size.x / viewSizeX);
	pass
