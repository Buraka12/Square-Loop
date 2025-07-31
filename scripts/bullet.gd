extends RigidBody2D

var pos : Vector2
const SPEED : float = 400.0

func _ready() -> void:
	var direction = (pos - global_position).normalized()
	linear_velocity += direction * SPEED
	rotation = get_angle_to(pos) + PI/2


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Entity"):
		body.die()
	queue_free()
