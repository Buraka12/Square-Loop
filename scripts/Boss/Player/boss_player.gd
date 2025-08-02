extends CharacterBody2D

@onready var die_menu: CanvasLayer = $Die_menu

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

var direction : float

var dodge_dur : float = 4
var dodge_speed : float = 1200
var dodge_cooldown : float = 0.7
var can_dodge : bool = true

const SPEED = 400.0

var jump_timer : float = 0.0
var is_jumping : bool = false
var jump_velocity : float = -450.0
var max_jump_time : float = 0.2

enum states {MOVE,STOP,FIRE,DODGE,DEAD}
var state : states = states.STOP

func _ready() -> void:
	$HurtBox/CollisionShape2D.disabled = true
	await get_tree().create_timer(0.1).timeout
	$HurtBox/CollisionShape2D.disabled = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += 40
	
	if Input.is_action_just_pressed("dodge") and state != states.DODGE:
		can_dodge = false
		state = states.DODGE
		$DodgeTimer.start(dodge_dur*delta)
		dodge()
	
	if Input.is_action_pressed("fire") and !reloading and ammo > 0 and can_fire:
		can_fire = false
		$FireRateTimer.start(1/fire_rate)
		fire()
	
	if ammo != max_ammo and Input.is_action_just_pressed("reload"):
		reloading = true
		$ReloadTimer.start(1)
		$player_ui/AnimationPlayer.play("reloading_ui")
		$player_ui/ammo_and_dodge/reload_ui/corner.visible = true

	if Input.is_action_just_pressed("laser") and can_laser:
		state = states.FIRE
		velocity += (global_position-get_global_mouse_position()).normalized()*laser_tab
		fire_laser()
	
	if Input.is_action_just_pressed("up") and is_on_floor() and state != states.DODGE:
		is_jumping = true
		jump_timer = 0.0
		velocity.y = jump_velocity
		
	if Input.is_action_pressed("up") and is_jumping and state != states.DODGE:
		jump_timer += delta
		if jump_timer < max_jump_time:
			velocity.y = jump_velocity
		else:
			is_jumping = false
	
	if Input.is_action_just_released("up"):
		is_jumping = false
	
	direction = Input.get_axis("left", "right")
	if state != states.DODGE:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func fire():
	var bullet = bulletscene.instantiate()
	var mouse_pos : Vector2 = get_global_mouse_position()
	bullet.global_position = $Marker2D.global_position
	bullet.pos = Vector2(global_position.x,0)
	$AnimationPlayer.play("Shoot")
	$"..".add_child(bullet)
	ammo -= 1
	$player_ui/ammo_and_dodge/HBoxContainer/ammo_label.text = str(ammo)
	if ammo == 0:
		$player_ui/ammo_and_dodge/HBoxContainer/sprite.frame = 3
	elif ammo <10:
		$player_ui/ammo_and_dodge/HBoxContainer/sprite.frame = 2
	elif ammo < 20:
		$player_ui/ammo_and_dodge/HBoxContainer/sprite.frame = 1

func fire_laser():
	can_laser = false
	laser.visible = true
	laser.deactive = false
	$LaserTimer.start(laser_dur)

func dodge():
	velocity.x = direction*dodge_speed
	$HurtBox.set_collision_mask_value(1,false)
	await get_tree().create_timer(dodge_dur).timeout
	state = states.STOP
	
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
	$player_ui/ammo_and_dodge/reload_ui/corner.visible = false
	$player_ui/ammo_and_dodge/HBoxContainer/ammo_label.text = str(ammo)
	$player_ui/ammo_and_dodge/HBoxContainer/sprite.frame = 0

func _on_laser_timer_timeout() -> void:
	if laser.visible:
		state = states.STOP
		laser.visible = false
		laser.deactive = true
		$LaserTimer.start(laser_cooldown)
	else:
		can_laser = true
