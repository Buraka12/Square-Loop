extends CharacterBody2D

var max_speed : float = 300.0
var speed : float = 0.0
var clutch : float = 200.0
var rot_speed : float = 700.0
@onready var area : Node2D = $".."
@onready var player: CharacterBody2D = area.find_child("Player")


func _physics_process(delta: float) -> void:
	set_speed(delta)
	rotation_degrees+=delta*rot_speed
	move_and_slide()

func set_speed(delta):
	if speed < max_speed:
		speed += delta * clutch
	var direction = (player.global_position - global_position).normalized()
	velocity = direction*speed

func die():
	queue_free()


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Entity"):
		body.die()
