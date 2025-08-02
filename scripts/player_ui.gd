extends CanvasLayer
@onready var enemy: Label = $"enemy count/HBoxContainer/enemy"
@onready var ammolabel: Label = $ammo_and_dodge_and_laser/HBoxContainer/ammo_label
@onready var sprite: Sprite2D = $ammo_and_dodge_and_laser/HBoxContainer/sprite
@onready var player: CharacterBody2D = $".."

@export var dodge_state : Color
@export var laser_state : float
@export var reload_state : int
@export var laser_dur : float

func _ready() -> void:
	$ammo_and_dodge_and_laser/reload_ui.visible = false

func _process(_delta: float) -> void:
	enemy.text = str(Global.entity)
	
func laser_anim():
	var tween = create_tween()
	tween.tween_property($ammo_and_dodge_and_laser/laser_ui/gradient,"scale:x",laser_state,laser_dur)

func dodge_anim():
	var tween = create_tween()
	tween.tween_property($ammo_and_dodge_and_laser/dodge_ui/dodge,"modulate",dodge_state,0.1)

func reload_anim():
	var tween = create_tween()
	tween.tween_property($ammo_and_dodge_and_laser/reload_ui/reload,"size:x",reload_state,1)
	tween.finished.connect(func():
		$ammo_and_dodge_and_laser/reload_ui/reload.size.x = 1
	)
