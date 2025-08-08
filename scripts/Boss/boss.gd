extends CharacterBody2D

var health : float = 150

var bullet_scene : PackedScene = load("res://scenes/enemy_bullet.tscn")
var fire_rate : float = 9.0

#Bitiş Rengi
@export var end_color : Color
@export var can_shoot : bool = true

#Saat Kollarının Hareketi
var times : Dictionary = {
	"Day":{"Rot":0,"Speed":TAU/5},
	"Hour":{"Rot":0,"Speed":TAU/2},
	"Minute":{"Rot":0,"Speed":TAU/1},
	"Second":{"Rot":0,"Speed":TAU/0.2}
}

func _ready() -> void:
	#Başlangıçta Kaç Saniye Bekleyecek
	var dur : int
	#İlk Defa Boss'a Geldiyse Daha Uzun Bekleycek
	if Global.first_time:
		dur = 5
	else:
		dur = 1
	await get_tree().create_timer(dur).timeout
	$AnimationPlayer.play("Idle")

func _process(delta: float) -> void:
	if Global.end:
		return
	set_rot(delta)
	if can_shoot:
		can_shoot = false
		$Timer.start(1/fire_rate)
		fire()

#Kolların Dönüşü
func set_rot(delta):
	var keys = times.keys()
	for i in keys:
		var clock = find_child(i)
		times[i]["Rot"]+=times[i]["Speed"]*delta
		if times[i]["Rot"] >= TAU:
			times[i]["Rot"] = 0
		
		clock.rotation = times[i]["Rot"]
		pass

#Ateş Etme
func fire():
	var bullet = bullet_scene.instantiate()
	bullet.SPEED = 250.0
	#Rastgele Konumlara Doğru Ateş Ediyor
	bullet.pos = Vector2(randi_range(0,1152),648)
	bullet.global_position = global_position
	$"..".add_child(bullet)

func die(damage = 1):
	if Global.end:
		return
	#Eğer Bölüm Başladıysa
	if $"..".start:
		health -= damage
		#Can Barı İçin Oran
		var ratio = health/150
		#Can Barının Büyüklüğünü Değiştirme
		$"../HEALTH/Border/TextureRect".scale.x = ratio
		#Öldü
		if health<=0:
			#Oyun Biter
			Global.end = true
			$"..".find_child("BossAnimations").play("End")
			$AnimationPlayer.play("Dead")
			#Boss Karartılır
			var tween = create_tween()
			tween.tween_property($".","modulate",end_color,5)
			tween.finished.connect(func():
				$".".queue_free()
				$"..".find_child("BossAnimations").stop()
				$"..".find_child("BossAnimations").play("Door")
			)

#Timer
func _on_timer_timeout() -> void:
	can_shoot = true
