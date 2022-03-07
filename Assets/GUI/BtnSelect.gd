extends TextureButton

export(bool) var hideNeighbours = true;

func _ready():
	get_node("Arrow").visible = false;
	pass

func _on_mouse_entered():
	if hideNeighbours:
		for node in get_parent().get_children():
			node.get_node("Arrow").visible = false;
	get_node("Arrow").visible = true;
	pass

func _on_mouse_exited():
	get_node("Arrow").visible = false;
