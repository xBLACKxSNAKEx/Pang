extends TextureButton

func _ready():
	get_node("Arrow").visible = false;
	pass

func _on_mouse_entered():
	for node in get_parent().get_children():
		node.get_node("Arrow").visible = false;
	get_node("Arrow").visible = true;
	pass
