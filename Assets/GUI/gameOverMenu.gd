extends Control

var l = 4

func _ready():
	get_node("Label").visible = false;
	get_node("ExitBtn").visible = false;
	visible = false;

func _physics_process(delta):
	if global.player.lifesLeft <= 0:
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
			get_node("Label").visible = true;
			get_node("ExitBtn").visible = true;
			get_node("Label").text = "Score: " + str(global.score);

func play_again():
	global.score = global.finalScore
	global.play();
	get_tree().paused = false;
	Engine.time_scale = 1;
	pass


func _on_ExitBtn_button_down():
	if get_parent().get_node("WinMenu").playerName == "" and global.mode == 2:
		get_parent().get_node("Name").visible = true;
	elif global.mode == 2:
		global.save_to_leaderboard(global.finalScore, get_parent().get_node("WinMenu").playerName);
		get_tree().paused = false;
		Engine.time_scale = 1;
		get_tree().change_scene("res://Start.tscn");
	else:
		get_tree().paused = false;
		Engine.time_scale = 1;
		get_tree().change_scene("res://Start.tscn");
	pass
