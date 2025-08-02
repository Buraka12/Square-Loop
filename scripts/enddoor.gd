extends Sprite2D


func _on_area_2d_body_entered(_body: Node2D) -> void:
	call_deferred("_change_scene", "res://scenes/end.tscn")

func _change_scene(path: String) -> void:
	get_tree().change_scene_to_file(path)
