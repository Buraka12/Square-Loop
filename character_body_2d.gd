extends CharacterBody2D


const SPEED = 300.0
func _physics_process(delta: float) -> void:
	
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
