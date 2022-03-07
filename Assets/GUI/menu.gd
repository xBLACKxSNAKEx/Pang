extends Node

var startMenuId = 0;
var playMenuId = 1;
var gamemodeMenuId = 2;
var mapMenu2Id = 3;
var savesMenuId = 4;
var optionsMenuId = 5;
var difficultyMenuId = 6;
var mapMenu3Id = 7;
var leaderboardMenuId = 8;

var activeMenuId;

func _ready():
	global.scan_saves();
	global.ballsList.clear();
	global.powerUps.clear();
	global.score = 0;
	global.finalScore = 0;
	Engine.time_scale = 1;
	get_tree().paused = false;
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

# Difficulty menu
func _on_SelectDifficulty_button_down(difficultyLevel):
	global.difficulty = difficultyLevel;
	if Input.is_key_pressed(KEY_CONTROL) and OS.is_debug_build():
		global.map = global.debugMap;
	else:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		global.map = rng.randi_range(1, 5);
	global.play();
	pass

# Play menu
func _on_NewGameBtn_button_down():
	if global.mode == 2:
		_select_menu(mapMenu2Id);
	else:
		_select_menu(mapMenu3Id);
	pass

func select_save():
	if get_node("SavesMenu/ItemList").is_anything_selected():
		global.load(get_node("SavesMenu/ItemList").get_item_text(get_node("SavesMenu/ItemList").get_selected_items()[0]));
	global.play();
	pass

func _on_ItemList_item_activated(index):
	global.load(get_node("SavesMenu/ItemList").get_item_text(index))
	global.play();
	pass

func del_save():
	if get_node("SavesMenu/ItemList").is_anything_selected():
		global.del_save(get_node("SavesMenu/ItemList").get_item_text(get_node("SavesMenu/ItemList").get_selected_items()[0]));
		global.scan_saves();

func _select_menu(id):
	get_child(startMenuId).visible = false;
	get_child(playMenuId).visible = false;
	get_child(gamemodeMenuId).visible = false;
	get_child(mapMenu2Id).visible = false;
	get_child(savesMenuId).visible = false;
	get_child(optionsMenuId).visible = false;
	get_child(difficultyMenuId).visible = false;
	get_child(mapMenu3Id).visible = false;
	get_child(leaderboardMenuId).visible = false;
	get_child(id).visible = true;
	activeMenuId = id;
	pass
