extends Node

var startMenuId = 0;
var playMenuId = 1;
var gamemodeMenuId = 2;
var mapMenu2Id = 3;
var savesMenuId = 4;
var optionsMenuId = 5;
var difficultyMenuId = 6;
var mapMenu3Id = 7;

var activeMenuId;

func _ready():
	# TODO: check stage1&2 maps and create buttons for them
	# TODO: check stage3 maps and create buttons for them
	_select_menu(startMenuId);
	pass

func _input(event):
	if event is InputEventKey:
		if event.pressed and (event.scancode == KEY_ENTER or event.scancode == KEY_SPACE):
			for node in get_child(activeMenuId).get_children():
				if node.get_child(0).visible:
					node.emit_signal("button_down");
					return
	pass

# Start menu
func _on_Start_button_down():
	_select_menu(gamemodeMenuId);
	pass

func _on_Options_button_down():
	_select_menu(optionsMenuId);
	pass

func _on_ExitBtn_button_down():
	get_tree().quit();
	pass

# Mode menu
func _on_SelectMode_button_down(mode):
	global.mode = mode;
	if mode == 1:
		_select_menu(difficultyMenuId);
	else:
		_select_menu(playMenuId);
	pass

func _on_BackModeBtn_button_down():
	_select_menu(startMenuId);
	pass

# Difficulty menu
func _on_SelectDifficulty_button_down(difficultyLevel):
	global.difficulty = difficultyLevel;
	if Input.is_key_pressed(KEY_CONTROL):
		global.map = 0;
		get_tree().change_scene("res://Game.tscn");
	else:
		if(global.mode == 1):
			var rng = RandomNumberGenerator.new()
			rng.randomize()
			if global.mapCount == 1:
				global.map = 1
			else:
				global.map = 1 + (rng.randi() % (global.mapCount - 1));
			_play();
		else:
			_select_menu(mapMenu2Id);
	pass

func _on_BackDiffBtn_button_down():
	_select_menu(gamemodeMenuId);
	pass

# Play menu
func _on_NewGameBtn_button_down():
	_select_menu(gamemodeMenuId);
	pass

func _on_LoadGameBtn_button_down():
	global.load();
	_play();
	#_select_menu(savesMenuId);
	pass

func _on_BackBtn_button_down():
	_select_menu(startMenuId);
	pass

func _play():
	get_tree().change_scene("res://Game.tscn");
	pass

# Map2/3 menu
func _on_BackMapBtn_button_down():
	_select_menu(difficultyMenuId);
	pass

# Saves menu
func _on_BackSavesBtn_button_down():
	_select_menu(playMenuId);
	pass

# Options menu
func _on_BackOptBtn_button_down():
	_select_menu(startMenuId);
	pass

func _select_menu(id):
	get_child(startMenuId).visible = false;
	get_child(playMenuId).visible = false;
	get_child(gamemodeMenuId).visible = false;
	get_child(mapMenu2Id).visible = false;
	get_child(savesMenuId).visible = false;
	get_child(optionsMenuId).visible = false;
	get_child(difficultyMenuId).visible = false;
	get_child(mapMenu3Id).visible = false;
	get_child(id).visible = true;
	activeMenuId = id;
	pass
