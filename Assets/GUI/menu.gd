extends Node

var startMenuId = 0;
var playMenuId = 1;
var gamemodeMenuId = 2;
var mapMenuId = 3;
var savesMenuId = 4;
var optionsMenuId = 5;
var difficultyMenuId = 6;

func _ready():
	# TODO: check stage1&2 maps and create buttons for them
	# TODO: check stage3 maps and create buttons for them
	_select_menu(startMenuId);
	pass

func _on_Start_button_down():
	_select_menu(playMenuId);
	pass

func _on_BackBtn_button_down():
	_select_menu(startMenuId);
	pass

func _on_NewGameBtn_button_down():
	_select_menu(gamemodeMenuId);
	pass

func _on_BackBtn1_button_down():
	_select_menu(playMenuId);
	pass

func _on_RandomBtn_button_down():
	global.mode = 1;
	_select_menu(difficultyMenuId);
	pass

func _on_SelectBtn_button_down():
	global.mode = 2;
	_select_menu(difficultyMenuId);
	pass

func _on_EndlessBtn_button_down():
	global.mode = 3;
	_select_menu(difficultyMenuId);
	pass

func _on_EasyBtn_button_down():
	global.difficulty = 1;
	_select_menu(mapMenuId);
	pass

func _on_MediumBtn_button_down():
	global.difficulty = 2;
	_select_menu(mapMenuId);
	pass

func _on_HardBtn_button_down():
	global.difficulty = 3;
	_select_menu(mapMenuId);
	pass

func _on_BackMapBtn_button_down():
	_select_menu(difficultyMenuId);
	pass

func _on_BackDiffBtn_button_down():
	_select_menu(gamemodeMenuId);
	pass

func _on_Options_button_down():
	_select_menu(optionsMenuId);
	pass

func _on_ExitBtn_button_down():
	get_tree().quit();
	pass

func _select_menu(id):
	for node in get_child(startMenuId).get_children():
		node.visible = 0;
	for node in get_child(playMenuId).get_children():
		node.visible = 0;
	for node in get_child(gamemodeMenuId).get_children():
		node.visible = 0;
	for node in get_child(mapMenuId).get_children():
		node.visible = 0;
	for node in get_child(savesMenuId).get_children():
		node.visible = 0;
	for node in get_child(optionsMenuId).get_children():
		node.visible = 0;
	for node in get_child(difficultyMenuId).get_children():
		node.visible = 0;
	for node in get_child(id).get_children():
		node.visible = 1;
	pass
