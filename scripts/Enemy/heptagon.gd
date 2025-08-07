extends Enemy

#Lazer ateşlemesi
var shooting : bool = false

func _ready() -> void:
	#Level ataması
	area = $".."
	player = area.find_child("Player")
	#Saniyede sıkılan mermi sayısı değiştirilir
	fire_rate = 0.2
	random_dur()
	#Varlık sayısı arttırılır
	Global.entity += 1
	#Başlangıç için durum atanır
	state = states.MOVE
	#Başlangıçta Lazer deaktive edilir
	$Laser.deactive = true

func _physics_process(_delta: float) -> void:
	if !shooting:
		look_at_player()
		#Yön ataması
		change_dir(-1)
	if can_shoot:
		fire(2)

#RunArea
func _on_run_area_body_entered(body: Node2D) -> void:
	#Oyuncu alana girerse kaç
	if body.name == "Player" and state != states.FIRE:
		state = states.MOVE

#RunArea
func _on_run_area_body_exited(body: Node2D) -> void:
	#Oyuncu alandan çıkarsa dur
	if body.name == "Player" and state != states.FIRE:
		state = states.STOP

#ShootTimer
func _on_shoot_timer_timeout() -> void:
	if state == states.FIRE:
		shooting = true
		#Lazerin sabit durduğu süre
		await get_tree().create_timer(0.4).timeout
		anim.stop()
		AudioManager.play("Laser_Enemy")
		#Lazer aktif sprite'a geçilir.
		$Laser.frame = 1
		velocity += direction*tab
		#Lazer aktif hale getirilir.
		$Laser.deactive = false
		#Lazerin ateşlendiği süre
		await get_tree().create_timer(0.4).timeout
		#Lazer deaktif hale getirilir.
		$Laser.deactive = true
		shooting = false
		anim.play("Normal")
		random_dur()
		state = states.MOVE
	else:
		can_shoot = true

#PathFinder
func _on_path_find_timer_timeout() -> void:
	#Belirli saniyede bir hedef konumu güncellenir
	agent.target_position = player.global_position
