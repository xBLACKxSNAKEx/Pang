extends RigidBody2D

export(int) var d = 4

const sizes = [0.49, 0.7, 1, 1.3];
export(float) var multiplier = 2;

onready var unbreakable_time = OS.get_ticks_msec()

var max_y_vel = 0;

export(float) var min_velocity_y = 90;
export(float) var max_velocity_y = 125;
export(float) var max_velocity_x = 200;

var rng = RandomNumberGenerator.new();

func _ready():
	if d < 1:
		queue_free();
	rng.randomize();
	pass

func set_Size():
	get_node("Sprite").scale = 0.333 * Vector2(1,1) * multiplier;
	get_node("Sprite").frame = d-1;
	get_node("CollisionShape2D").scale = Vector2(1,1) * sizes[d-1] * multiplier;
	mass = d;
	pass

var s = 1

func _physics_process(delta):
	if global.sizeUp > 0 or s != 1:
		if global.sizeUp > 0:
			s += delta * 0.5;
			if s > 2:
				s = 2;
		else:
			s -= delta * 0.5;
			if s < 1:
				s = 1;
		get_node("Sprite").scale = 0.333 * Vector2(1,1) * multiplier * s;
		get_node("Sprite").frame = d-1;
		get_node("CollisionShape2D").scale = Vector2(1,1) * sizes[d-1] * multiplier * s;
	else:
		set_Size()
	var v = sqrt(linear_velocity.x*linear_velocity.x + linear_velocity.y*linear_velocity.y)
	if v > sqrt(max_velocity_y * max_velocity_y + max_velocity_x * max_velocity_x):
		var normalized = Vector2(linear_velocity.x / v, linear_velocity.y/v)
		apply_central_impulse(-normalized * 5 * d)
	if linear_velocity.x > max_velocity_x * d * d:
		linear_damp = 1/4*d;
	elif linear_velocity.x < -max_velocity_x * d * d:
		linear_damp = 1/4*d;
	else:
		linear_damp = 0;
	
	if linear_velocity.y > -2 and linear_velocity.y < 2:
		if max_y_vel != 0:
			if max_y_vel < min_velocity_y + 25 * (d - 1):
				apply_central_impulse(Vector2(0, 20) * d)
			max_y_vel = 0;
	else:
		if linear_velocity.y > max_velocity_y + 25 * (d - 1):
			apply_central_impulse(-Vector2(0, linear_velocity.y))
		if linear_velocity.y > max_y_vel:
			max_y_vel = linear_velocity.y;
	if d <= 0:
		if global.ballsList.find(self) != -1:
			global.ballsList.remove(global.ballsList.find(self));
		if get_parent().get_child_count() == 1:
			get_parent().queue_free();
		else:
			queue_free()
		return
	pass

func pop():
	var particleResource = "res://Assets/Ball/Particles/Pop_Ball_" + String(d) + ".tscn"
	var particlesLoad = load(particleResource)
	var particles = particlesLoad.instance()
	particles.global_position = global_position;
	get_parent().add_child(particles)
	particles.emitting = true;
	if rng.randf_range(0, 100) < global.powerUpChance:
		var powerUpResource = "res://Assets/PowerUps/PowerUp.tscn";
		var powerUpLoad = load(powerUpResource)
		var powerUp = powerUpLoad.instance()
		get_parent().add_child(powerUp)
		powerUp.global_position = global_position;
		powerUp.setType(rng.randi_range(0,2));
	particles.emitting = true;
	if d <= 1:
		if global.ballsList.find(self) != -1:
			global.ballsList.remove(global.ballsList.find(self));
		if get_parent().get_child_count() == 1:
			get_parent().queue_free();
		else:
			queue_free()
	pass

func hit():
	if OS.get_ticks_msec() - unbreakable_time > 150:
		unbreakable_time = OS.get_ticks_msec();
		split();
	pass

func split():
	global.score += global.scores[d-1];
	if d <= 1:
		pop();
		return
	s = 1;
	var dup = duplicate();
	pop();
	d-=1;
	dup.d = d;
	dup.unbreakable_time = OS.get_ticks_msec();
	get_parent().add_child(dup)
	global.ballsList.push_back(dup)
	apply_impulse(Vector2(0,0), Vector2(100, 0))
	dup.apply_impulse(Vector2(0,0), Vector2(-100, 0))
	set_Size()
	dup.set_Size()
	pass
