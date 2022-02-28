extends Node2D

export(PackedScene) var ball_scene = preload("res://Assets/Ball/Scenes/Ball.tscn")
export(PackedScene) var player_scene = preload("res://Assets/Player/Scenes/Player.tscn")

var rng = RandomNumberGenerator.new();

# Called when the node enters the scene tree for the first time.
func _ready():
	var mapPath = "res://Assets/Maps/Map" + String(global.map) + ".tscn"
	var next_level_resource = load(mapPath)
	rng.randomize();
	var next_level = next_level_resource.instance()
	add_child(next_level)
	var player = player_scene.instance()
	add_child(player)
	global.player = player;
	if global.save == "":
		spawn_balls()
		player.global_position = get_node("Node2D/Player").global_position
	else:
		player.global_position.x = global.player_pos_x;
		player.global_position.y = global.player_pos_y;
		player.lifes_left = global.player_lifes;
		for spawn in get_child(2).get_node("SpawnPoints").get_children():
			spawn.visible = false
		for i in global.ballsList.size():
			var b = spawn_ball(Vector2(global.ballsList[0].posx, global.ballsList[0].posy), global.ballsList[0].size, 0, 0);
			b.linear_velocity.x = global.ballsList[0].velx;
			b.linear_velocity.y = global.ballsList[0].vely;
			global.ballsList.pop_front();
			global.ballsList.push_back(b);
	get_node("Node2D/Player").visible = false
	pass

func spawn_balls():
	for spawn in get_child(2).get_node("SpawnPoints").get_children():
		spawn.visible = false
		var easy = spawn.easy_Balls_Spawn;
		var normal = spawn.normal_Balls_Spawn;
		var hard = spawn.hell_Balls_Spawn;
		var random_velocity = spawn.random_velocity;
		var random_angle = spawn.random_angle;
		var init_vel
		var init_angle
		if random_velocity == false:
			init_vel = spawn.init_vel;
		else:
			init_vel = -1;
			
		if random_angle == false:
			init_angle = spawn.init_angle;
		else:
			init_angle = -1;
		
		if global.difficulty == global.Difficulty.Easy:
			if easy > 0:
				global.ballsList.push_back(spawn_ball(spawn.global_position, easy, init_vel, init_angle));
		elif global.difficulty == global.Difficulty.Normal:
			if normal > 0:
				global.ballsList.push_back(spawn_ball(spawn.global_position, normal, init_vel, init_angle));
		elif global.difficulty == global.Difficulty.Hard:
			if hard > 0:
				global.ballsList.push_back(spawn_ball(spawn.global_position, hard, init_vel, init_angle));
	pass

func spawn_ball(spawn_global_position, d, init_vel, init_angle):
	var instance = ball_scene.instance()
	instance.global_position = spawn_global_position
	add_child(instance)
	instance.d = d;
	var angle
	var force
	
	if init_angle < 0:
		angle = (2 * PI * rng.randf_range(5, 60))/360
	else:
		angle = (2 * PI * init_angle)/360;
	
	if init_vel < 0:
		force = rng.randf_range(90,150)
	else:
		force = init_vel;
	
	if rng.randi() % 2 == 1:
		instance.apply_central_impulse(Vector2(sin(angle) * force, cos(angle)*force));
	else:
		instance.apply_central_impulse(Vector2(sin(2*PI-angle) * force, cos(2*PI - angle)*force));
	return instance
