extends CharacterBody2D

var direction = Vector2.ZERO
var dodge_speed : float = 700
var dodge_dur : float = 0.2
var bulletscene : PackedScene = preload("res://scenes/player_bullet.tscn")

enum states {MOVE,STOP,FIRE,DODGE}
var state : states = states.MOVE

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("fire") and state != states.DODGE:
		fire()
	
	if Input.is_action_just_pressed("dodge") and state != states.DODGE:
		state = states.DODGE
		$DodgeTimer.start(dodge_dur)
		dodge()
	
	#mouse bakma
	look_at(get_global_mouse_position())

	#sağ sol yukarı aşağı hareket
	direction.y = Input.get_axis("up" , "down")
	direction.x = Input.get_axis("left" , "right")
	
	if state != states.DODGE and direction != Vector2(0,0):
		state = states.MOVE

func fire():
	var bullet = bulletscene.instantiate()
	var mouse_pos : Vector2 = get_global_mouse_position()
	bullet.global_position = $Marker2D.global_position
	bullet.pos = mouse_pos
	$AnimationPlayer.play("Shoot")
	$"..".add_child(bullet)

func dodge():
	velocity = direction.normalized()*dodge_speed
	$HurtBox.set_collision_mask_value(1,false)

func die():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_dodge_timer_timeout() -> void:
	state = states.STOP
	$HurtBox.set_collision_mask_value(1,true)
