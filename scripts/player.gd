extends CharacterBody2D

@onready var die_menu: CanvasLayer = $Die_menu

var direction = Vector2.ZERO
var dodge_speed : float = 800.0
#Dokunulmaz olma süresi.(*delta)
var dodge_dur : float = 6.5
var dodge_cooldown : float = 0.4
var can_dodge : bool = true

var bulletscene : PackedScene = preload("res://scenes/player_bullet.tscn")
var fire_rate : float = 5.0
var can_fire : bool = true
var max_ammo : int = 30
var ammo : int = 30
var reloading : bool = false

@onready var laser : Sprite2D = $PlayerLaser
var laser_cooldown : float = 4.0
var laser_dur : float = 0.2
#Lazer geri sekmesi
var laser_tab : float = 300.0
var can_laser : bool = true

enum states {MOVE,STOP,FIRE,DODGE,DEAD}
var state : states = states.MOVE

func _ready() -> void:
	#İlk defa mı bölüme başladı?
	if !Global.level_start:
		$level_start.next()

func _physics_process(delta: float) -> void:
	#Öldüyse siktir et herşeyi
	if state == states.DEAD:
		return
	
	#Ateş Etme
	if check_fire():
		can_fire = false
		#Bekleme süresi
		$FireRateTimer.start(1/fire_rate)
		#Ses
		AudioManager.play("Shoot_Player")
		fire()
	
	#Mermi Doldurma
	if ammo != max_ammo and Input.is_action_just_pressed("reload"):
		reloading = true
		#Ne kadar sürede dolduracak
		$ReloadTimer.start(1)
		#UI göstergesi
		$player_ui/AnimationPlayer.play("reloading_ui")
		$player_ui/ammo_and_dodge_and_laser/reload_ui.visible = true
	
	#Lazer Ateşleme
	if Input.is_action_just_pressed("laser") and can_laser:
		state = states.FIRE
		#Geri Tepme
		velocity += (global_position-get_global_mouse_position()).normalized()*laser_tab
		#Ses
		AudioManager.play("Laser_Player")
		fire_laser()
	
	#Dodge Atma
	if check_dodge():
		can_dodge = false
		state = states.DODGE
		#Ne kadar süre dodge atacak
		$DodgeTimer.start(dodge_dur*delta)
		#UI göstergesi
		$player_ui/AnimationPlayer.play("dodge_using")
		#Ses
		AudioManager.play("Dash",0.5)
		dodge()
	
	#Mouse bakma
	look_at(get_global_mouse_position())

	#sağ sol yukarı aşağı hareket
	direction.y = Input.get_axis("up" , "down")
	direction.x = Input.get_axis("left" , "right")
	
	#Hareket Etme
	if check_move():
		state = states.MOVE

func check_move():
	return state != states.DODGE and direction != Vector2(0,0) and state != states.FIRE

func check_dodge():
	return Input.is_action_just_pressed("dodge") and state != states.DODGE and can_dodge

func check_fire():
	return Input.is_action_pressed("fire") and state != states.DODGE and can_fire and ammo > 0 and !reloading

func fire():
	#Yeni mermi
	var bullet = bulletscene.instantiate()
	var mouse_pos : Vector2 = get_global_mouse_position()
	bullet.global_position = $Marker2D.global_position
	#Merminin yöneleceği nokta
	bullet.pos = mouse_pos
	$AnimationPlayer.play("Shoot")
	#Mermiyi bölüme ekle
	$"..".add_child(bullet)
	ammo -= 1
	#UI değiştirme
	$player_ui/ammo_and_dodge_and_laser/HBoxContainer/ammo_label.text = str(ammo)
	#Mermi sayısına göre sprite değiştirme
	if ammo == 0:
		$player_ui/ammo_and_dodge_and_laser/HBoxContainer/sprite.frame = 3
	elif ammo <10:
		$player_ui/ammo_and_dodge_and_laser/HBoxContainer/sprite.frame = 2
	elif ammo < 20:
		$player_ui/ammo_and_dodge_and_laser/HBoxContainer/sprite.frame = 1

func fire_laser():
	can_laser = false
	laser.visible = true
	#Lazer aktif hale getirilir
	laser.deactive = false
	#Lazer kaç saniye aktif kalacak
	$LaserTimer.start(laser_dur)
	#UI göstergesi
	$player_ui/AnimationPlayer.play("laser_use")

func dodge():
	velocity = direction.normalized()*dodge_speed
	#HurtBox ın player kısmını deaktif eder. Bu sayede mermiler hurtbox ile etkileşime girmez.
	$HurtBox.set_collision_mask_value(1,false)
	
func die(_damage = 1):
	#Eğer dodge atarken mermi değerse yok sayar.
	if state != states.DODGE:
		#Oyun durur.
		get_tree().paused = true
		state = states.DEAD
		Global.entity = 0
		#UI gösterilir
		die_menu.show_game_over_message()
		die_menu.visible = true

#DodgeTimer
func _on_dodge_timer_timeout() -> void:
	if state == states.DODGE:
		state = states.STOP
		$HurtBox.set_collision_mask_value(1,true)
		$DodgeTimer.start(dodge_cooldown)
		$player_ui/AnimationPlayer.play("dodge_reload")
	else:
		can_dodge = true

#FireRateTimer
func _on_fire_rate_timer_timeout() -> void:
	can_fire = true

#ReloadTimer
func _on_reload_timer_timeout() -> void:
	ammo = max_ammo
	reloading = false
	$player_ui/ammo_and_dodge_and_laser/reload_ui.visible = false
	$player_ui/ammo_and_dodge_and_laser/HBoxContainer/ammo_label.text = str(ammo)
	$player_ui/ammo_and_dodge_and_laser/HBoxContainer/sprite.frame = 0

#LaserTimer
func _on_laser_timer_timeout() -> void:
	#Eğer lazer zaten aktif ise kapatmak için
	if laser.visible:
		state = states.STOP
		laser.visible = false
		laser.deactive = true
		#Lazer kaç saniye sonra tekrar ateşlenebilir olacak
		$LaserTimer.start(laser_cooldown)
		#UI göstergesi
		$player_ui/AnimationPlayer.play("laser_reload")
	#Lazer ateşlenebilir değil ise de ateşlenebilir hale getirilir
	else:
		can_laser = true
