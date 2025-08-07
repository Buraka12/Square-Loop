extends CharacterBody2D

@onready var area : Node2D = $".."
@onready var player : CharacterBody2D = area.find_child("Player")
@onready var agent: NavigationAgent2D = $NavigationAgent2D

@onready var bulletscene : PackedScene = load("res://scenes/enemy_bullet.tscn")
var can_shoot : bool = false
var fire_rate : float = 0.3
var tab : float = 1000.0

var direction : Vector2

enum states {STOP,MOVE,FIRE}
var state : states

func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var wait_time = rng.randf_range(0.5, 1.0)
	$Timer.start(wait_time/fire_rate)
	Global.entity += 1
	state = states.MOVE

func _physics_process(_delta: float) -> void:
	direction = (agent.get_next_path_position()-global_position).normalized()
	look_at_player()
	if can_shoot:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var wait_time = rng.randf_range(0.5, 1.0)
		can_shoot = false
		velocity = -direction*tab
		move_and_slide()
		$Timer.start(wait_time/fire_rate)
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
	var offsets = [-16, 0, 16]
	var dist = Vector2(-direction.y, direction.x)
	var a : int = 0
	for i in $Points.get_children():
		var bullet = bulletscene.instantiate()
		bullet.pos = player.global_position + dist * offsets[a]
		bullet.global_position = i.global_position
		area.add_child(bullet)
		a+=1
		AudioManager.play("Shoot_Pentagon")
	$AnimationPlayer.play("Shoot")

func _on_stop_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		state = states.STOP

func _on_stop_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		state = states.MOVE

func _on_timer_timeout() -> void:
	can_shoot = true

func _on_path_find_timer_timeout() -> void:
	agent.target_position = player.global_position
