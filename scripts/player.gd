extends CharacterBody2D

const SPEED = 250.0

var bulletscene : PackedScene = preload("res://scenes/player_bullet.tscn")

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("fire"):
		fire()
	
	#mouse bakma
	look_at(get_global_mouse_position())

	#sağ sol yukarı aşağı hareket
	var direction = Vector2.ZERO
	direction.y = Input.get_axis("up" , "down")
	direction.x = Input.get_axis("left" , "right")
	
	if direction :
		velocity = direction.normalized() * SPEED
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()

func fire():
	var bullet = bulletscene.instantiate()
	var mouse_pos : Vector2 = get_global_mouse_position()
	bullet.global_position = $Marker2D.global_position
	bullet.pos = mouse_pos
	$AnimationPlayer.play("Shoot")
	$"..".add_child(bullet)

func die():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
