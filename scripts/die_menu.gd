extends CanvasLayer

@onready var die_menu: CanvasLayer = $"."

@onready var restart_button: Button = $blur/corner/VBoxContainer/HBoxContainer/restart_button
@onready var main_menu: Button = $"blur/corner/VBoxContainer/HBoxContainer/main menu"
@onready var exit_button: Button = $blur/corner/VBoxContainer/HBoxContainer/exit_button


func _ready() -> void:
	die_menu.visible = false
	restart_button.pressed.connect(restart)
	main_menu.pressed.connect(returnMainMenu)
	exit_button.pressed.connect(get_tree().quit)
	
func returnMainMenu():
	Global.entity = 0
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func restart():
	Global.entity = 0
	var now_level = str(Global.level)
	var next_file = "res://scenes/levels/level_"+ now_level +".tscn"
	get_tree().change_scene_to_file(next_file)
	
