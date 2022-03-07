extends ItemList

export(String) var basePath = "//Assets/Maps/ss/Map"
export(int) var mapsVisible = 5;

func _ready():
	for i in range(1, mapsVisible + 1):
		add_item("Map " + str(i), load("res:" + basePath + str(i) + ".png"));
	pass

func _physics_process(delta):
	if is_anything_selected():
		for i in range(global.mapCount):
			if is_selected(i):
				global.map = (i % 5) + 1;
				global.difficulty = i / 5;
				global.play();
	pass
