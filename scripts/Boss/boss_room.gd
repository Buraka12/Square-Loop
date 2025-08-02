extends Node2D

var attacks : Array = [
	"Corner_Lazer",
	"Line_Lazer",
	"Middle_Lazer",
	"Bottom_Lazer",
	"Middle_Empty_Lazer",
	"Bottom_Empty_Lazer"
]

var random_time : int
var timer : Timer

func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(attack)
	timer.one_shot = true
	random_time = randi_range(3,4)
	timer.start(random_time)


func attack():
	var random_attack_id = randi_range(0,attacks.size()-1)
	$BossAnimations.play(attacks[random_attack_id ])
	random_time = randi_range(3,4)
	timer.start(random_time)
