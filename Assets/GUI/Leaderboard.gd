extends Control

export(PackedScene) var leaderboardEntryScene = preload("res://Assets/GUI/leaderboard-entry.tscn")

var firstFontColor = Color("#D933FF");
var secondFontColor = Color("#D933FF");
var thirdFontColor = Color("#D933FF");
var lightFontColor = Color("#EB33FF");
var darkFontColor = Color("#EB33FF");

func _ready():
	global.load_Leaderboard();
	var i = 1;
	for e in global.leaderboard:
		var entry = e as global.LeaderEntry;
		var leaderboardEntry = leaderboardEntryScene.instance();
		if i > 3:
			leaderboardEntry.get_node("Number").visible = true;
			leaderboardEntry.get_node("Number").text = str(i);
			if i % 2 == 0:
				leaderboardEntry.get_node("Leaderboard-entry-dark").visible = false;
				leaderboardEntry.get_node("Name").add_color_override("font_color", darkFontColor);
				leaderboardEntry.get_node("Score").add_color_override("font_color", darkFontColor);
				leaderboardEntry.get_node("Number").add_color_override("font_color", darkFontColor);
			else:
				leaderboardEntry.get_node("Name").add_color_override("font_color", lightFontColor);
				leaderboardEntry.get_node("Score").add_color_override("font_color", lightFontColor);
				leaderboardEntry.get_node("Number").add_color_override("font_color", lightFontColor);
		else:
			leaderboardEntry.get_node("Number").visible = false;
			leaderboardEntry.get_node("Leaderboard-entry-dark").visible = false;
			leaderboardEntry.get_node("Leaderboard-entry-light").visible = false;
			leaderboardEntry.get_node("Leaderboard-entry-bronze").visible = false;
			leaderboardEntry.get_node("Leaderboard-entry-silver").visible = false;
			leaderboardEntry.get_node("Leaderboard-entry-gold").visible = false;
			if i == 1:
				leaderboardEntry.get_node("Number").visible = false;
				leaderboardEntry.get_node("Leaderboard-entry-gold").visible = true;
				leaderboardEntry.get_node("Name").add_color_override("font_color", firstFontColor);
				leaderboardEntry.get_node("Score").add_color_override("font_color", firstFontColor);
			elif i == 2:
				leaderboardEntry.get_node("Number").visible = false;
				leaderboardEntry.get_node("Leaderboard-entry-silver").visible = true;
				leaderboardEntry.get_node("Name").add_color_override("font_color", secondFontColor);
				leaderboardEntry.get_node("Score").add_color_override("font_color", secondFontColor);
			else:
				leaderboardEntry.get_node("Number").visible = false;
				leaderboardEntry.get_node("Leaderboard-entry-bronze").visible = true;
				leaderboardEntry.get_node("Name").add_color_override("font_color", thirdFontColor);
				leaderboardEntry.get_node("Score").add_color_override("font_color", thirdFontColor);
		leaderboardEntry.get_node("Name").text = entry.name;
		leaderboardEntry.get_node("Score").text = str(entry.score);
		get_node("ScrollContainer/VBoxContainer").add_child(leaderboardEntry);
		i+=1;
