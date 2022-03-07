extends Control

var l = 4

onready var level = global.difficulty * global.mapCountPerDifficulty + global.map;

onready var millis = OS.get_ticks_msec();

var playerName = "";

func _ready():
	get_child(0).modulate.a = 0;
	get_child(1).visible = false;
	get_child(2).visible = false;
	get_child(3).visible = false;
	visible = false;
	pass

func _physics_process(delta):
	if OS.get_ticks_msec() - millis > 1000:
		if global.ballsList.size() <= 0 and global.player.lifesLeft > 0:
			global.finalScore = global.score;
			if get_child(0).modulate.a < 255:
				get_tree().paused = true;
				Engine.time_scale = 1;
				visible = true;
				get_child(0).modulate.a += delta;
			else:
				get_child(0).modulate.a = 255;
			if l > 0:
				l -= delta
			else:
				l = 0;
				get_child(global.mode).visible = true;
				get_child(global.mode).get_node("Label").text = "Score: " + str(global.score);
				if global.mode == 2:
					if global.difficulty == global.Difficulty.Hard:
						if global.map == 5:
							get_node("Mode2/ContinueBtn").visible = false;
							get_node("Mode2/SaveBtn").visible = false;
						else:
							get_node("Mode2/ContinueBtn").visible = true;
							get_node("Mode2/SaveBtn").visible = true;
	pass


func _on_ExitBtn_button_down():
	if playerName == "" and global.mode == 2:
		get_parent().get_node("Name").visible = true;
	elif global.mode == 2:
		global.ballsList.clear();
		global.save_to_leaderboard(global.finalScore, playerName);
		global.save = "";
		get_tree().paused = false;
		Engine.time_scale = 1;
		get_tree().change_scene("res://Start.tscn");
	else:
		get_tree().paused = false;
		Engine.time_scale = 1;
		get_tree().change_scene("res://Start.tscn");
	pass

func nextLevel():
	global.map += 1;
	if global.map > 5:
		global.map = 1;
		global.difficulty += 1;
	get_tree().change_scene("res://Game.tscn");
	Engine.time_scale = 1;
	get_tree().paused = false;
	pass

func save():
	global.save();
	get_tree().paused = false;
	Engine.time_scale = 1;
	get_tree().change_scene("res://Start.tscn");
	pass

func accept():
	get_parent().get_node("Name").visible = false;
	playerName = get_parent().get_node("Name/LineEdit").text;
	pass

func cancel():
	get_parent().get_node("Name").visible = false;
	pass

func _on_NewGameBtn_button_down():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	global.map = rng.randi_range(1, 5);
	global.play();
	get_tree().paused = false;
	Engine.time_scale = 1;
	pass
