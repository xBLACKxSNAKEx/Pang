extends Control

func _ready():
	visible = false;
	var file = File.new();
	if file.file_exists("user://options.dat"):
		file.open("user://options.dat", File.READ);
		var masterValue = file.get_8();
		var musicValue = file.get_8();
		var effectsValue = file.get_8();
		get_node("Master").value = masterValue
		get_node("Music").value = musicValue;
		get_node("Effects").value = effectsValue;
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), map(-50.0, 0.0, 0.0, 100.0, masterValue))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), map(-50.0, 0.0, 0.0, 100.0, musicValue))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effects"), map(-50.0, 0.0, 0.0, 100.0, effectsValue))
		file.close();
	else:
		file.open("user://options.dat", File.WRITE);
		file.store_8(100);
		file.store_8(100);
		file.store_8(100);
		file.close();
	pass

func saveVolume():
	var file = File.new();
	file.open("user://options.dat", File.WRITE);
	file.store_8(get_node("Master").value);
	file.store_8(get_node("Music").value);
	file.store_8(get_node("Effects").value);
	file.close();
	pass

func _on_Master_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), map(-50.0, 0.0, 0.0, 100.0, value));
	saveVolume()
	pass

func _on_Music_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), map(-50.0, 0.0, 0.0, 100.0, value));
	saveVolume()
	pass

func _on_Effects_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effects"), map(-50.0, 0.0, 0.0, 100.0, value));
	saveVolume()
	pass

func map(minTo, maxTo, minFrom, maxFrom, value):
	var maxA = maxTo - minTo;
	var maxB = maxFrom - minFrom;
	var t = value * maxA / maxB;
	t = t + minTo;
	return t;
	pass
