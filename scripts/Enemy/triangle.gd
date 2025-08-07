extends Enemy

func _ready() -> void:
	#Level ataması
	area = $".."
	player = area.find_child("Player")
	random_dur()
	#Varlık sayısı arttırılır
	Global.entity += 1
	#Başlangıç için durum atanır
	state = states.MOVE

func _physics_process(_delta: float) -> void:
	#Yön ataması
	change_dir(1)
	look_at_player()
	#Ateş edebilir mi kontrolü
	if can_shoot:
		fire(0)
		random_dur()
		#Geri tepme için hız ayarı
		velocity = -direction*tab
		#Geri tepmeden dolayı hareket ettirme
		move_and_slide()

#StopArea
func _on_stop_area_body_entered(body: Node2D) -> void:
	#Oyuncu alana girdiyse düşman durur
	if body.name == "Player":
		state = states.STOP

#StopArea
func _on_stop_area_body_exited(body: Node2D) -> void:
	#Oyuncu alandan çıktıysa düşman hareket eder
	if body.name == "Player":
		state = states.MOVE

#ShootTimer
func _on_shoot_timer_timeout() -> void:
	can_shoot = true

#PathFinderTimer
func _on_path_find_timer_timeout() -> void:
	#Belirli saniyede bir hedef konumu güncellenir
	agent.target_position = player.global_position
