extends Label

var score = 0;

func _ready():
	text = "0";
	pass

func _physics_process(delta):
	if global.score != score:
		score = global.score;
		text = "Score: " + str(score);
