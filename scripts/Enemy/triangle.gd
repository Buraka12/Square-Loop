extends CharacterBody2D

@onready var area : Node2D = $".."
@onready var player : CharacterBody2D = area.find_child("Player")

@onready var bulletscene : PackedScene = load("res://scenes/enemy_bullet.tscn")
var can_shoot : bool = true
var fire_rate : float = 0.6
var tab : float = 400.0

var direction : Vector2

enum states {STOP,MOVE,FIRE}
var state : states

func _ready() -> void:
	Global.entity += 1
	state = states.MOVE

func _physics_process(delta: float) -> void:
	look_at_player()
	direction = (player.global_position-global_position).normalized()
	if can_shoot:
		can_shoot = false
		velocity = -direction*tab
		move_and_slide()
		$Timer.start(1/fire_rate)
		fire()


func look_at_player():
	look_at(player.global_position)
	rotation_degrees += 90

func die(damage = 1):
	Global.entity -= 1
	Global.CheckEntity_LevelChange()
	queue_free()

func fire():
	var bullet = bulletscene.instantiate()
	bullet.pos = player.global_position
	bullet.global_position = $Marker2D.global_position
	$AnimationPlayer.play("Shoot")
	AudioManager.play("Shoot_Triangle")
	area.add_child(bullet)

func _on_stop_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		state = states.STOP

func _on_stop_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		state = states.MOVE

func _on_timer_timeout() -> void:
	can_shoot = true
