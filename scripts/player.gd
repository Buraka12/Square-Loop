extends CharacterBody2D

@onready var die_menu: CanvasLayer = $Die_menu

var direction = Vector2.ZERO
var dodge_speed : float = 800.0
var dodge_dur : float = 5
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
var laser_tab : float = 300.0
var can_laser : bool = true

enum states {MOVE,STOP,FIRE,DODGE,DEAD}
var state : states = states.MOVE

func _physics_process(delta: float) -> void:
	if state == states.DEAD:
		return
	if Input.is_action_pressed("fire") and state != states.DODGE and can_fire and ammo > 0 and !reloading:
		can_fire = false
		$FireRateTimer.start(1/fire_rate)
		fire()
	
	if ammo != max_ammo and Input.is_action_just_pressed("reload"):
		reloading = true
		$ReloadTimer.start(1)
	
	if Input.is_action_just_pressed("laser") and can_laser:
		state = states.FIRE
		velocity += (global_position-get_global_mouse_position()).normalized()*laser_tab
		fire_laser()
	
	if Input.is_action_just_pressed("dodge") and state != states.DODGE and can_dodge:
		can_dodge = false
		state = states.DODGE
		$DodgeTimer.start(dodge_dur*delta)
		dodge()
	
	#mouse bakma
	look_at(get_global_mouse_position())

	#sağ sol yukarı aşağı hareket
	direction.y = Input.get_axis("up" , "down")
	direction.x = Input.get_axis("left" , "right")
	
	if state != states.DODGE and direction != Vector2(0,0) and state != states.FIRE:
		state = states.MOVE

func fire():
	var bullet = bulletscene.instantiate()
	var mouse_pos : Vector2 = get_global_mouse_position()
	bullet.global_position = $Marker2D.global_position
	bullet.pos = mouse_pos
	$AnimationPlayer.play("Shoot")
	$"..".add_child(bullet)
	ammo -= 1
	$player_ui/ammo_and_dodge/HBoxContainer/ammo_label.text = str(ammo)

func fire_laser():
	can_laser = false
	laser.visible = true
	laser.deactive = false
	$LaserTimer.start(laser_dur)
	

func dodge():
	velocity = direction.normalized()*dodge_speed
	$HurtBox.set_collision_mask_value(1,false)
	
func die():
	if state != states.DODGE:
		get_tree().paused = true
		state = states.DEAD
		Global.entity = 0
		die_menu.show_game_over_message()
		die_menu.visible = true
	

func _on_dodge_timer_timeout() -> void:
	if state == states.DODGE:
		state = states.STOP
		$HurtBox.set_collision_mask_value(1,true)
		$DodgeTimer.start(dodge_cooldown)
	else:
		can_dodge = true

func _on_fire_rate_timer_timeout() -> void:
	can_fire = true

func _on_reload_timer_timeout() -> void:
	ammo = max_ammo
	reloading = false

func _on_laser_timer_timeout() -> void:
	if laser.visible:
		state = states.STOP
		laser.visible = false
		laser.deactive = true
		$LaserTimer.start(laser_cooldown)
	else:
		can_laser = true
