extends CanvasLayer
@onready var enemy: Label = $Panel/HBoxContainer/enemy


func _process(delta: float) -> void:
	enemy.text = str(Global.entity)
