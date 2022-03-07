extends KinematicBody2D

export(PackedScene) var bulletScene = preload("res://Assets/Guns/Laser.tscn")
export(PackedScene) var shootSoundScene = preload("res://Sounds/Shoot.tscn")
export(PackedScene) var hitSoundScene = preload("res://Sounds/Hit.tscn")

const GRAVITY = 10;
const WALK_SPEED = 200;
const JUMP = 400;

const INVINCIBILITY_TIME = 1.5;

var lifesLeft = 5;

var velocity = Vector2();
var jump = false;
onready var lastHit = OS.get_ticks_msec();

var lastPos = Vector2();

var click = 0;

onready var animation = get_node("AnimatedSprite");
onready var walk = get_node("/root/global/Walk");
var oncePlayed = true;

var onLadder = false;

func setLifes(lifes):
	lifesLeft = lifes;
pass

func _input(event):
	if event is InputEventKey:
		if global.ballsList.size() > 0 and event.pressed and event.scancode == KEY_SPACE:
			shoot();
	pass

func _process(delta):
	if animation.animation == "MoveRight" or animation.animation == "MoveLeft":
		
		if animation.frame == 1 or animation.frame == 3:
			if oncePlayed == false:
				oncePlayed = true;
				if walk.playing == false:
					walk.playing = true;
		else:
			oncePlayed = false;
	pass

func _physics_process(delta):
	if onLadder:
		velocity.y = 0;
	else:
		velocity.y += GRAVITY;
	
	if global.ballsList.size() > 0 and Input.is_action_pressed("ui_left"):
		velocity.x = -WALK_SPEED;
		if jump == true and not onLadder:
			animation.animation = "JumpLeft";
		else:
			if animation.animation != "MoveLeft":
				animation.animation = "MoveLeft";
				walk.playing = true;
	elif global.ballsList.size() > 0 and Input.is_action_pressed("ui_right"):
		velocity.x =  WALK_SPEED;
		if jump == true and not onLadder:
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
	
	if onLadder:
		get_node("Collider").disabled = true;
		if global.ballsList.size() > 0 and Input.is_action_pressed("ui_up"):
			velocity.y = -JUMP;
		elif global.ballsList.size() > 0 and Input.is_action_pressed("ui_down"):
			velocity.y = JUMP;
	else:
		get_node("Collider").disabled = false;
		if is_on_floor():
			if global.slowmo > 0:
				velocity.y = 0.1;
			else:
				velocity.y = 0.1;
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
	if abs(position.y - lastPos.y) < abs(velocity.y * delta / 1.1):
		velocity.y = 0;
	
	lastPos = position
	
	if OS.get_ticks_msec() - lastHit <= INVINCIBILITY_TIME * 1000:
		if OS.get_ticks_msec() - click > 150:
			click = OS.get_ticks_msec();
			get_child(0).modulate.a = -get_child(0).modulate.a;
	else:
		get_child(0).modulate.a = 1;
	pass

func shoot():
	var bullet = bulletScene.instance();
	var shootSound = shootSoundScene.instance();
	get_parent().add_child(shootSound)
	shootSound.playing = true;
	get_parent().add_child(bullet)
	bullet.global_position = global_position + Vector2(0, -10);
	bullet.linear_velocity.y = -150;
	bullet.linear_velocity.x = 0;
	pass

func _on_Area2D_body_entered(body):
	if body.get_collision_layer_bit(global.boubbleCollisionLayer):
		if OS.get_ticks_msec() - lastHit > INVINCIBILITY_TIME * 1000:
			var hitSound = hitSoundScene.instance();
			get_parent().add_child(hitSound)
			hitSound.playing = true;
			lastHit = OS.get_ticks_msec();
			lifesLeft-=1;
			if lifesLeft <= 0:
				get_tree().paused = true;
	elif body.get_collision_layer_bit(global.powerUpCollisionLayer):
		if body.type == 0:
			global.sizeUp = global.sizeUpTime;
		elif body.type == 1:
			if lifesLeft >= global.maxLifes:
				lifesLeft = global.maxLifes;
				global.score += global.scores[4];
			else:
				lifesLeft+=1;
		elif body.type == 2:
			global.slowmo = global.slowmoTime;
		global.powerUps.remove(global.powerUps.find(body));
		body.queue_free();
	pass

func _on_Area2D_area_entered(area):
	if area.get_collision_layer_bit(global.ladderCollisionLayer):
		onLadder = true;
	pass


func _on_Area2D_area_exited(area):
	if area.get_collision_layer_bit(global.ladderCollisionLayer):
		onLadder = false;
	pass
