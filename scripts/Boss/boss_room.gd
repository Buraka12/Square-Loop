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

#Rastgele Yeni Saldırı Zamanı
var random_time : int
#Timer
var timer : Timer

@export var shooting : bool = false

#Bölüm Başladı mı?
var start : bool = false

func _ready() -> void:
	#İlk Defa Gelindiyse Giriş Animasyonu İçin
	start = !Global.first_time
	$Transis.visible = Global.first_time
	#İlk defa ise Giriş Animasyonu
	if Global.first_time:
		Global.first_time = false
		$BossAnimations.play("Player_Start")
		await get_tree().create_timer(4.1).timeout
		#Başlat
		start = !Global.first_time
	$BossAnimations.play("Start")
	#İlk Saldırı İçin Zamanlayıcı Başlangıcı
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(attack)
	timer.one_shot = true
	random_time = randi_range(3,4)
	timer.start(random_time)

func _process(_delta: float) -> void:
	if Global.end:
		$HEALTH.visible = false
		return
	#Boss'dan gelen lazeri sürekli oyuncuya döndürme.
	#Her zaman döner ama sadece saldırı yapılacağı zaman görünür olur.
	if !shooting and start:
		var to_player = $Player.global_position - $Boss/Laser.global_position
		$Boss/Laser.global_rotation = to_player.angle() + deg_to_rad(90)

func play_laser():
	AudioManager.play("Laser_Enemy")

#Saldırıyı Başlat
#AnimationPlayer İle Yapılır
func attack():
	if Global.end:
		return
	var random_attack_id = randi_range(0,attacks.size()-1)
	$BossAnimations.play(attacks[random_attack_id ])
	random_time = randi_range(3,4)
	timer.start(random_time)
