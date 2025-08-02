extends Sprite2D

@export var deactive: bool = false

func free() -> void:
	$HitBox/CollisionShape2D.disabled = deactive

func _process(delta: float) -> void:
	$HitBox/CollisionShape2D.disabled = deactive

func _on_hit_box_area_entered(area: Node2D) -> void:
	if area.name == "HurtBox":
		area.get_parent().die()
