extends Sprite2D


func _on_hit_box_area_entered(area: Node2D) -> void:
	if area.name == "HurtBox":
		area.get_parent().die()
