extends CharacterBody2D


var SPEED = 250.0

var bulletscene : PackedScene = preload("res://scenes/player_bullet.tscn")
var can_shoot : bool = true
var fire_rate : float = 2
var shooting : bool = false

func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("fire") and can_shoot:
		SPEED = 100.0
		can_shoot = false
		shooting = true
		$Timer.start(1/fire_rate)
		fire()
	if Input.is_action_just_released("fire"):
		SPEED = 250.0
		shooting = false
	
	#mouse bakma
	look_at(get_global_mouse_position())
	
	#sağ sol yukarı aşağı hareket
	var directionx := Input.get_axis("left" , "right")
	if directionx:
		velocity.x = directionx * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	var directiony := Input.get_axis("up", "down")
	if directiony:
		velocity.y = directiony * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

func fire():
	var bullet = bulletscene.instantiate()
	var mouse_pos : Vector2 = get_global_mouse_position()
	bullet.global_position = global_position
	bullet.pos = mouse_pos
	$"..".add_child(bullet)

func die():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_timer_timeout() -> void:
	can_shoot = true
