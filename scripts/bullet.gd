extends RigidBody2D

var pos : Vector2
const SPEED : float = 500.0
var dur : float = 6.0
var time : float = 0.0

func _ready() -> void:
	var direction = (pos - global_position).normalized()
	linear_velocity += direction * SPEED
	rotation = get_angle_to(pos) + PI/2

func _process(delta: float) -> void:
	time+=delta
	var ratio = time/dur
	if ratio >= 1:
		queue_free()

func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Entity"):
		body.die()
	queue_free()
