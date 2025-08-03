extends CharacterBody2D

@onready var area : Node2D = $".."
@onready var player : CharacterBody2D = area.find_child("Player")

var shooting : bool = false
var can_shoot : bool = true
var fire_rate : float = 0.2
var tab : float = 400.0

var direction : Vector2

enum states {STOP,MOVE,FIRE}
var state : states

func _ready() -> void:
	Global.entity += 1
	print(Global.entity)
	state = states.MOVE
	$Laser.deactive = true

func _physics_process(_delta: float) -> void:
	if !shooting:
		look_at_player()
		direction = -(player.global_position-global_position).normalized()
	if can_shoot:
		fire()


func look_at_player():
	look_at(player.global_position)
	rotation_degrees += 90

func die(_damage = 1):
	Global.entity -= 1
	Global.next = true
	Global.CheckEntity_LevelChange()
	call_deferred("queue_free")

func fire():
	can_shoot = false
	state = states.FIRE
	$AnimationPlayer.play("Shoot")
	$Timer.start(1)

func _on_run_area_body_entered(body: Node2D) -> void:
	if body.name == "Player" and state != states.FIRE:
		state = states.MOVE

func _on_run_area_body_exited(body: Node2D) -> void:
	if body.name == "Player" and state != states.FIRE:
		state = states.STOP

func _on_timer_timeout() -> void:
	if state == states.FIRE:
		shooting = true
		await get_tree().create_timer(0.4).timeout
		$AnimationPlayer.stop()
		AudioManager.play("Laser_Enemy")
		$Laser.frame = 1
		velocity += direction*tab
		$Laser.deactive = false
		await get_tree().create_timer(0.4).timeout
		$Laser.deactive = true
		shooting = false
		$AnimationPlayer.play("Normal")
		$Timer.start(1/fire_rate)
		state = states.MOVE
	else:
		can_shoot = true
