extends CanvasLayer

func _ready() -> void:
	get_tree().paused = true
	await get_tree().create_timer(3).timeout
	get_tree().paused = false
