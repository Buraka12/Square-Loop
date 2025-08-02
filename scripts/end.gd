extends Node2D

func _ready() -> void:
	get_tree().paused = true
	await get_tree().create_timer(3).timeout
	get_tree().paused = false

func _unhandled_input(_event: InputEvent) -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
