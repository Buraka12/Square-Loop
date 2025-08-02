extends Node2D

var attacks : Array = [
	"Corner_Lazer",
	"Line_Lazer",
	"Middle_Lazer",
	"Bottom_Lazer",
	"Middle_Empty_Lazer",
	"Bottom_Empty_Lazer",
	"BossLazer"
]

var random_time : int
var timer : Timer

@export var shooting : bool = false

func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(attack)
	timer.one_shot = true
	random_time = randi_range(3,4)
	timer.start(random_time)

func _process(delta: float) -> void:
	if !shooting:
		var to_player = $Player.global_position - $Boss/Laser.global_position
		$Boss/Laser.global_rotation = to_player.angle() + deg_to_rad(90)
	

func attack():
	var random_attack_id = randi_range(0,attacks.size()-1)
	$BossAnimations.play(attacks[random_attack_id ])
	random_time = randi_range(3,4)
	timer.start(random_time)
