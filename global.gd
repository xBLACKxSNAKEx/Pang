extends Node2D

export(PackedScene) var music = preload("res://Sounds/Music.tscn")
export(PackedScene) var walk = preload("res://Sounds/Walk.tscn")

# develop options
var mapCount = 5;

var max_lifes = 6;

var powerUpChance = 10;

var mapCollisionLayer = 0;
var playerCollisionLayer = 1;
var boubbleCollisionLayer = 2;
var bulletCollisionLayer = 3;
var powerUpCollisionLayer = 4;

var slowmoTime = 15;
var sizeUpTime = 20;

var scores = [5,3,2,1, 5]


# play options
var difficulty = Difficulty.Easy;
var map = 0;
var mode = 0;
var save = "";

var player;
var player_pos_x;
var player_pos_y;
var player_lifes;

# power ups
var slowmo = 0;
var slow_scale = 1;
var sizeUp = 0;

# game options
var ballsList = []
var score = 0;

func _ready():
	var music0 = music.instance()
	add_child(music0);
	var walk0 = walk.instance()
	add_child(walk0);
	pass

func _physics_process(delta):
	if slowmo > 0 or slow_scale != 1:
		if slowmo > 0:
			slow_scale -= delta * 0.25;
			if slow_scale < 0.5:
				slow_scale = 0.5;
			Engine.time_scale = slow_scale;
			slowmo -= delta;
		else:
			slowmo = 0;
			if slow_scale > 1:
				slow_scale = 1;
			slow_scale += delta * 0.25;
			Engine.time_scale = slow_scale;
	if sizeUp > 0:
		sizeUp -= delta;
	else:
		sizeUp = 0;
	pass
	
func save():
	var file = File.new()
	file.open("user://saves/save1/boubles.dat", File.WRITE)
	file.store_double(player.global_position.x);
	file.store_double(player.global_position.y);
	file.store_8(player.lifes_left);
	file.store_16(ballsList.size())
	for bouble in ballsList:
		file.store_double(bouble.global_position.x);
		file.store_double(bouble.global_position.y);
		file.store_double(bouble.linear_velocity.x);
		file.store_double(bouble.linear_velocity.y);
		file.store_8(bouble.d);
	file.close()
	pass

func load():
	var file = File.new()
	file.open("user://saves/save1/boubles.dat", File.READ)
	player_pos_x = file.get_double();
	player_pos_y = file.get_double();
	player_lifes = file.get_8();
	var j = file.get_16();
	for i in range(j):
		var position_x = file.get_double();
		var position_y = file.get_double();
		var velocity_x = file.get_double();
		var velocity_y = file.get_double();
		var size = file.get_8();
		var b = Boubble.new()
		b.posx = position_x;
		b.posy = position_y;
		b.velx = velocity_x;
		b.vely = velocity_y;
		b.size = size;
		ballsList.push_back(b);
		b = ballsList[ballsList.size()-1]
	file.close()
	save = "save1";
	pass

enum Difficulty {
	 Easy,
	 Normal,
	 Hard
}

class Boubble:
	var posx
	var posy
	var velx
	var vely
	var size
