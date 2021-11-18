extends Node2D

export(PackedScene) var ball_scene = preload("res://Scenes/Ball.tscn")

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	pass

func _unhandled_input(event):
	if event.is_echo():
		return
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == BUTTON_LEFT:
			spawn(get_global_mouse_position())


func spawn(spawn_global_position):
	var instance = ball_scene.instance()
	instance.global_position = spawn_global_position
	add_child(instance)
	instance.get_node("Ball").linear_velocity = Vector2(rng.randf_range(-10.0, 10.0)*10, rng.randf_range(-10.0, 10.0)*10)
