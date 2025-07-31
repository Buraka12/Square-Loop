extends CharacterBody2D

@onready var area : Node2D = $".."
@onready var player : CharacterBody2D = area.find_child("Player")

@onready var bulletscene : PackedScene = load("res://scenes/enemy_bullet.tscn")
var can_shoot : bool = true
var fire_rate : float = 1

var health : float = 100
const SPEED = 200.0

enum states {STOP,FOLLOW,FIRE}
var state : states

func _ready() -> void:
	state = states.FOLLOW

func _physics_process(delta: float) -> void:
	look_at_player()
	if state != states.STOP:
		follow_player()
	else:
		velocity = Vector2(0,0)
	
	if can_shoot:
		can_shoot = false
		$Timer.start(1/fire_rate)
		fire()
	
	move_and_slide()

func follow_player():
	var direction = (player.global_position-global_position).normalized()
	velocity = direction*SPEED

func look_at_player():
	look_at(player.global_position)
	rotation_degrees += 90

func die():
	queue_free()

func fire():
	var bullet = bulletscene.instantiate()
	bullet.pos = player.global_position
	bullet.global_position = global_position
	area.add_child(bullet)

func _on_stop_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		state = states.STOP

func _on_stop_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		state = states.FOLLOW

func _on_timer_timeout() -> void:
	can_shoot = true
