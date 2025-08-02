extends CanvasLayer
@onready var enemy: Label = $"enemy count/HBoxContainer/enemy"
@onready var ammolabel: Label = $ammo/HBoxContainer/ammo
@onready var sprite: Sprite2D = $ammo/HBoxContainer/sprite
@onready var player: CharacterBody2D = $".."

func _ready() -> void:
	$ammo_and_dodge/reload_ui/corner.visible = false

func _process(delta: float) -> void:
	enemy.text = str(Global.entity)
