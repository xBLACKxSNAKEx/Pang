extends RigidBody2D

export(int) var type = 0;

var s;
var e;

func _ready():
	get_node("Sprite0").visible = false;
	get_node("Sprite1").visible = false;
	get_node("Sprite2").visible = false;
	get_node("Sprite" + str(type)).visible = true;
	var rng = RandomNumberGenerator.new();
	rng.randomize()
	s = rng.randf_range(0, 30);
	e = rng.randi_range(0, 1);
	pass

func _physics_process(delta):
	if e:
		if s > 30:
			e = false;
			s = 30;
		else:
			s += 10 * delta;
	else:
		if s < 0:
			s = 0;
			e = true;
		else:
			s -= 10 * delta;
	get_node("Sprite0").offset.y = -s;
	get_node("Sprite1").offset.y = -s;
	get_node("Sprite2").offset.y = -s;

func setType(var t):
	type = t;
	get_node("Sprite0").visible = false;
	get_node("Sprite1").visible = false;
	get_node("Sprite2").visible = false;
	get_node("Sprite" + str(t)).visible = true;
	pass
