extends CharacterBody2D


const SPEED = 250.0
var bulletscene : PackedScene = preload("res://scenes/Player/player_bullet.tscn")

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("fire"):
		fire()
	
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
