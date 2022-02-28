extends KinematicBody2D

export(PackedScene) var laser_bullet_scene = preload("res://Assets/Guns/Laser.tscn")
export(PackedScene) var gun_sound = preload("res://Sounds/Shoot.tscn")
export(PackedScene) var hit_sound = preload("res://Sounds/Hit.tscn")

const GRAVITY = 10;
const WALK_SPEED = 200;
const JUMP = 400;

const INVINCIBILITY_TIME = 1.5;

var lifes_left = 5;

var velocity = Vector2();
var jump = false;
onready var last_death = OS.get_ticks_msec();

var last_pos = Vector2();

var click = 0;

onready var animation = get_node("AnimatedSprite");
onready var walk = get_node("/root/global/Walk");
var once_plyed = true;

func setLifes(lifes):
	lifes_left = lifes;
pass

func _input(event):
	if event is InputEventKey:
		if global.ballsList.size() > 0 and event.pressed and event.scancode == KEY_SPACE:
			shoot();
		if OS.is_debug_build() and event.pressed and event.scancode == KEY_X:
			for boubble in global.ballsList:
				boubble.hit();
	pass

func _process(delta):
	if animation.animation == "MoveRight" or animation.animation == "MoveLeft":
		
		if animation.frame == 1 or animation.frame == 3:
			if once_plyed == false:
				once_plyed = true;
				if walk.playing == false:
					walk.playing = true;
		else:
			once_plyed = false;
	pass

func _physics_process(delta):
	velocity.y += GRAVITY;
	
	if global.ballsList.size() > 0 and Input.is_action_pressed("ui_left"):
		velocity.x = -WALK_SPEED;
		if jump == true:
			animation.animation = "JumpLeft";
		else:
			if animation.animation != "MoveLeft":
				animation.animation = "MoveLeft";
				walk.playing = true;
	elif global.ballsList.size() > 0 and Input.is_action_pressed("ui_right"):
		velocity.x =  WALK_SPEED;
		if jump == true:
			animation.animation = "JumpRight";
		else:
			if animation.animation != "MoveRight":
				animation.animation = "MoveRight";
				walk.playing = true;
	else:
		walk.playing = false;
		velocity.x = 0;
		if animation.animation == "MoveRight":
			animation.animation = "IdleRight";
		elif animation.animation == "MoveLeft":
			animation.animation = "IdleLeft";
	
	if global.slowmo > 0:
		velocity.x *= 2;
	
	move_and_slide(Vector2(velocity.x, 0), Vector2(0,-1));
		
	if is_on_floor():
		if global.slowmo > 0:
			velocity.y = GRAVITY * 2;
		else:
			velocity.y = GRAVITY;
		if global.ballsList.size() > 0 and Input.is_action_pressed("ui_up"):
			if not jump:
				if animation.animation == "MoveLeft" or animation.animation == "IdleLeft":
					animation.animation = "JumpLeft";
				elif animation.animation == "MoveRight" or animation.animation == "IdleRight":
					animation.animation = "JumpRight";
				if global.slowmo > 0:
					velocity.y = -JUMP * 2;
				else:
					velocity.y = -JUMP;
				jump = true;
			else:
				jump = false;
				if animation.animation == "JumpLeft":
					animation.animation = "IdleLeft";
				elif animation.animation == "JumpRight":
					animation.animation = "IdleRight";
		else:
			jump = false;
			if animation.animation == "JumpLeft":
				animation.animation = "IdleLeft";
			elif animation.animation == "JumpRight":
				animation.animation = "IdleRight";
	
	move_and_slide(Vector2(0, velocity.y), Vector2(0,-1));
	if abs(position.y - last_pos.y) < abs(velocity.y * delta / 1.1):
		velocity.y = 0;
	
	last_pos = position
	
	if OS.get_ticks_msec() - last_death <= INVINCIBILITY_TIME * 1000:
		if OS.get_ticks_msec() - click > 150:
			click = OS.get_ticks_msec();
			get_child(0).modulate.a = -get_child(0).modulate.a;
	else:
		get_child(0).modulate.a = 1;
	pass

func shoot():
	var bullet = laser_bullet_scene.instance();
	var shoot_effect = gun_sound.instance();
	get_parent().add_child(shoot_effect)
	shoot_effect.playing = true;
	get_parent().add_child(bullet)
	bullet.global_position = global_position + Vector2(0, -10);
	bullet.linear_velocity.y = -150;
	bullet.linear_velocity.x = 0;
	pass

func _on_Area2D_body_entered(body):
	if body.get_collision_layer_bit(global.boubbleCollisionLayer):
		if OS.get_ticks_msec() - last_death > INVINCIBILITY_TIME * 1000:
			var hit_effect = hit_sound.instance();
			get_parent().add_child(hit_effect)
			hit_effect.playing = true;
			last_death = OS.get_ticks_msec();
			lifes_left-=1;
			if lifes_left <= 0:
				get_tree().paused = true;
	elif body.get_collision_layer_bit(global.powerUpCollisionLayer):
		if body.type == 0:
			global.sizeUp = global.sizeUpTime;
			body.queue_free();
		elif body.type == 1:
			if lifes_left >= global.max_lifes:
				lifes_left = global.max_lifes;
				global.score += global.scores[4];
			else:
				lifes_left+=1;
			body.queue_free();
		elif body.type == 2:
			global.slowmo = global.slowmoTime;
			body.queue_free();
	pass
