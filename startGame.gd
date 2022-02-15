extends Node2D

export(PackedScene) var ball_scene = preload("res://Assets/Ball/Scenes/Ball.tscn")
export(PackedScene) var player_scene = preload("res://Assets/Player/Scenes/Player.tscn")

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	var mapPath = "res://Assets/Maps/Map" + String(global.map) + ".tscn"
	var next_level_resource = load(mapPath)
	rng.randomize()
	var next_level = next_level_resource.instance()
	add_child(next_level)
	spawn_balls()
#	var player = player_scene.instance()
#	add_child(player)
#	player.get_child(0).setLifes(1)
	pass

func spawn_balls():
	for spawns in get_child(0).get_node("SpawnPoints").get_children():
		spawns.visible = false
		var name = spawns.name.to_lower()
		if "hard" in name: # Hard
			if global.difficulty > 2:
				spawn_ball(spawns.position)
		elif "easy" in name: # Easy
			spawn_ball(spawns.position)
		else:	# Normal
			if global.difficulty > 1:
				spawn_ball(spawns.position)
	pass

func spawn_ball(spawn_global_position):
	var instance = ball_scene.instance()
	instance.global_position = spawn_global_position
	add_child(instance)
	
	var angle = (2 * PI * rng.randf_range(5, 60))/360
	var force = rng.randf_range(90,150)
	
	if rng.randi() % 2 == 1:
		instance.get_node("Ball").apply_central_impulse(Vector2(sin(angle) * force, cos(angle)*force))
	else:
		instance.get_node("Ball").apply_central_impulse(Vector2(sin(2*PI-angle) * force, cos(2*PI - angle)*force))
