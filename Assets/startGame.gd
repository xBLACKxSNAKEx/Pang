extends Node2D

export(PackedScene) var ballScene = preload("res://Assets/Ball/Ball.tscn")
export(PackedScene) var playerScene = preload("res://Assets/Player/Player.tscn")

var rng = RandomNumberGenerator.new();

# Called when the node enters the scene tree for the first time.
func _ready():
	if global.save != "":
		if global.ballsList.size() <= 0:
			global.map +=1;
			if global.map > global.mapCountPerDifficulty:
				global.map = 1;
				global.difficulty += 1;
			global.save = "";
	var mapPath = "res://Assets/Maps/Map" + String(global.map) + ".tscn"
	if global.mode == 3:
		mapPath = "res://Assets/Maps/Stage3/Map" + String(global.map) + ".tscn"
	var nextLevelResource = load(mapPath)
	rng.randomize();
	var nextLevel = nextLevelResource.instance()
	add_child(nextLevel)
	var player = playerScene.instance()
	add_child(player)
	global.player = player;
	if global.save == "":
		global.ballsList.clear();
		spawn_balls()
		player.global_position = get_node("Node2D/Player").global_position
	else:
		if global.playerPosX == null:
			player.global_position = get_node("Node2D/Player").global_position
		else:
			player.global_position.x = global.playerPosX;
			player.global_position.y = global.playerPosY;
		if global.playerLifes != null:
			player.lifesLeft = global.playerLifes;
		for spawn in get_child(3).get_node("SpawnPoints").get_children():
			spawn.visible = false
		for i in global.ballsList.size():
			var b = spawn_ball(Vector2(global.ballsList[0].posX, global.ballsList[0].posY), global.ballsList[0].size, 0, 0);
			b.linear_velocity.x = global.ballsList[0].velX;
			b.linear_velocity.y = global.ballsList[0].velY;
			global.ballsList.pop_front();
			global.ballsList.push_back(b);
		var powerUpResource = "res://Assets/PowerUps/PowerUp.tscn";
		var powerUpLoad = load(powerUpResource)
		for i in global.powerUps.size():
			var powerUp = powerUpLoad.instance()
			powerUp.global_position.x = global.powerUps[i].posX;
			powerUp.global_position.y = global.powerUps[i].posY;
			powerUp.setType(global.powerUps[i].type);
			get_node("/root/Node2D/MAP/PowerUps").add_child(powerUp)
			global.save = "";
	get_node("Node2D/Player").visible = false
	if global.mode == 2:
		get_node("UI/Game_Mode/Level").visible = true;
		get_node("UI/Game_Mode/Level").text = "Level " + str(global.map + (global.mapCountPerDifficulty * global.difficulty));
	else:
		get_node("UI/Game_Mode/Level").visible = false;
	Engine.time_scale = 1;
	get_tree().paused = false;
	pass

func spawn_balls():
	for spawn in get_child(3).get_node("SpawnPoints").get_children():
		spawn.visible = false
		var easy = spawn.easyBallsSpawn;
		var normal = spawn.normalBalls_Spawn;
		var hard = spawn.hardBalls_Spawn;
		var randomVelocity = spawn.randomVelocity;
		var randomAngle = spawn.randomAngle;
		var initVel
		var initAngle
		if randomVelocity == false:
			initVel = spawn.initVel;
		else:
			initVel = -1;
			
		if randomAngle == false:
			initAngle = spawn.initAngle;
		else:
			initAngle = -1;
		
		if global.difficulty == global.Difficulty.Easy:
			if easy > 0:
				global.ballsList.push_back(spawn_ball(spawn.global_position, easy, initVel, initAngle));
		elif global.difficulty == global.Difficulty.Normal:
			if normal > 0:
				global.ballsList.push_back(spawn_ball(spawn.global_position, normal, initVel, initAngle));
		elif global.difficulty == global.Difficulty.Hard:
			if hard > 0:
				global.ballsList.push_back(spawn_ball(spawn.global_position, hard, initVel, initAngle));
	pass

func spawn_ball(spawn_global_position, d, initVel, initAngle):
	var instance = ballScene.instance()
	instance.global_position = spawn_global_position
	add_child(instance)
	instance.d = d;
	var angle
	var force
	
	if initAngle < 0:
		angle = (2 * PI * rng.randf_range(5, 60))/360
	else:
		angle = (2 * PI * initAngle)/360;
	
	if initVel < 0:
		force = rng.randf_range(90,150)
	else:
		force = initVel;
	
	if rng.randi() % 2 == 1:
		instance.apply_central_impulse(Vector2(sin(angle) * force, cos(angle)*force));
	else:
		instance.apply_central_impulse(Vector2(sin(2*PI-angle) * force, cos(2*PI - angle)*force));
	return instance
