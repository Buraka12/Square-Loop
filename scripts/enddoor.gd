extends Sprite2D


#Oyuncu kapıya temas ettiyse.
func _on_area_2d_body_entered(_body: Node2D) -> void:
	#Önce fizik olayları biter, sonra sahne değiştirilir.
	call_deferred("_change_scene", "res://scenes/end.tscn")

func _change_scene(path: String) -> void:
	#Sahne değiştirme
	get_tree().change_scene_to_file(path)
