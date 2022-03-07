extends Node2D

export(PackedScene) var music = preload("res://Sounds/Music.tscn")
export(PackedScene) var walk = preload("res://Sounds/Walk.tscn")

# develop options
var debugMap = 0;

var mapCount = 15;
var mapCountPerDifficulty = 5;

var maxLifes = 6;

var powerUpChance = 10;

var mapCollisionLayer = 0;
var playerCollisionLayer = 1;
var boubbleCollisionLayer = 2;
var bulletCollisionLayer = 3;
var powerUpCollisionLayer = 4;
var ladderCollisionLayer = 5;

var slowmoTime = 15;
var sizeUpTime = 20;

var scores = [5,3,2,1, 5]

# play options
var difficulty = Difficulty.Easy;
var map = 0;
var mode = 0;
var save = "";

var player;
var playerPosX;
var playerPosY;
var playerLifes;

# power ups
var slowmo = 0;
var slowScale = 1;
var sizeUp = 0;

# game options
var ballsList = []
var score = 0;
var finalScore = 0;

var powerUps = [];

func _ready():
	var music0 = music.instance()
	add_child(music0);
	var walk0 = walk.instance()
	add_child(walk0);
	var dir = Directory.new()
	if dir.open("user://saves") != OK:
		dir.make_dir("user://saves");
	pause_mode = Node.PAUSE_MODE_PROCESS;
	pass

func _physics_process(delta):
	if slowmo > 0 or slowScale != 1:
		if slowmo > 0:
			slowScale -= delta * 0.25;
			if slowScale < 0.5:
				slowScale = 0.5;
			Engine.time_scale = slowScale;
			slowmo -= delta;
		else:
			slowmo = 0;
			if slowScale > 1:
				slowScale = 1;
			slowScale += delta * 0.25;
			Engine.time_scale = slowScale;
	if sizeUp > 0:
		sizeUp -= delta;
	else:
		sizeUp = 0;
	pass

func scan_saves():
	get_node("/root/Control/Menus/SavesMenu/ItemList").clear();
	var files = [];
	var dir = Directory.new();
	dir.open("user://saves");
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
	dir.list_dir_end();
	for s in files:
		var filename = s.get_basename();
		filename = filename.replace(".dat", "");
		get_node("/root/Control/Menus/SavesMenu/ItemList").add_item(filename);
	pass;

func del_save(name):
	var dir = Directory.new();
	dir.open("user://saves/");
	if dir.file_exists(name + ".dat"):
		dir.remove(name + ".dat");
		print("Deleted file " + name + ".dat");
	else:
		print("File " + name + ".dat does not exist");
	pass

func cmp(a, b):
	var entryA = a as LeaderEntry;
	var entryB = b as LeaderEntry;
	return entryA.score > entryB.score;

func save_to_leaderboard(score, name):
	var entry = LeaderEntry.new();
	entry.name = name;
	entry.score = score;
	leaderboard.push_back(entry);
	leaderboard.sort_custom(self, "cmp")
	if leaderboard.size() >= 10:
		leaderboard.pop_back();
	var dir = Directory.new()
	dir.remove("user://leaderboard.dat");
	var file = File.new()
	file.open("user://leaderboard.dat", File.WRITE_READ);
	file.store_8(leaderboard.size());
	for e in leaderboard:
		file.store_32(e.score);
		file.store_8(e.name.length());
		file.store_buffer(e.name.to_utf8());
	file.close();
	pass

var leaderboard = [];

func load_Leaderboard():
	leaderboard.clear();
	var file = File.new();
	if not file.file_exists("user://leaderboard.dat"):
		file.open("user://leaderboard.dat", File.WRITE_READ);
		file.store_8(0);
		file.flush();
		file.close();
	file.open("user://leaderboard.dat", File.READ_WRITE);
	var j = file.get_8();
	print(j);
	var i = 0;
	while i < 10 and i < j:
		var value = file.get_32();
		var length = file.get_8();
		var name = file.get_buffer(length).get_string_from_utf8();
		var entry = LeaderEntry.new();
		entry.name = name;
		entry.score = value;
		leaderboard.push_back(entry);
		i+=1;
	file.close();
	leaderboard.sort_custom(self, "cmp");

class LeaderEntry:
	var score;
	var name;

func save():
	var file = File.new()
	var time = OS.get_time();
	var date = OS.get_date();
	var timeReturn = String(date["year"]) + "-" + String(date["month"]) + "-" + String(date["day"]) + "-" + String(time.hour) +"-"+String(time.minute)+"-"+String(time.second)
	file.open("user://saves/" + timeReturn + ".dat", File.WRITE)
	file.store_double(player.global_position.x);
	file.store_double(player.global_position.y);
	file.store_8(player.lifesLeft);
	
	file.store_32(score);
	file.store_32(finalScore);
	
	file.store_8(mode);
	file.store_8(map);
	file.store_8(difficulty);
	
	file.store_32(slowmo);
	file.store_32(sizeUp);
	
	file.store_16(ballsList.size())
	for bouble in ballsList:
		file.store_double(bouble.global_position.x);
		file.store_double(bouble.global_position.y);
		file.store_double(bouble.linear_velocity.x);
		file.store_double(bouble.linear_velocity.y);
		file.store_8(bouble.d);
	file.store_16(powerUps.size())
	for powerup in powerUps:
		if powerup != null:
			file.store_double(powerup.position.x);
			file.store_double(powerup.position.y);
			file.store_8(powerup.type);
	file.close()
	pass

func load(name):
	var file = File.new()
	file.open("user://saves/" + name + ".dat", File.READ)
	playerPosX = file.get_double();
	playerPosY = file.get_double();
	playerLifes = file.get_8();
	
	score = file.get_32()
	finalScore = file.get_32()
	
	mode = file.get_8();
	map = file.get_8();
	difficulty = file.get_8();
	
	slowmo = file.get_32();
	sizeUp = file.get_32();
	
	var j = file.get_16();
	for i in range(j):
		var positionX = file.get_double();
		var positionY = file.get_double();
		var velocityX = file.get_double();
		var velocityY = file.get_double();
		var size = file.get_8();
		var b = Boubble.new()
		b.posX = positionX;
		b.posY = positionY;
		b.velX = velocityX;
		b.velY = velocityY;
		b.size = size;
		ballsList.push_back(b);
	j = file.get_16();
	for i in range(j):
		var positionX = file.get_double();
		var positionY = file.get_double();
		var type = file.get_8();
		var p = PowerUp.new();
		p.posX = positionX;
		p.posY = positionY;
		p.type = type;
		powerUps.push_back(p);
	file.close()
	save = name;
	pass

func play():
	score = finalScore;
	get_tree().change_scene("res://Game.tscn");
	pass

enum Difficulty {
	 Easy,
	 Normal,
	 Hard
}

class Boubble:
	var posX
	var posY
	var velX
	var velY
	var size

class PowerUp:
	var posX
	var posY
	var type
