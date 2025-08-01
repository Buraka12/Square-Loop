extends Control

@onready var main_buttons: VBoxContainer = $Main_buttons
@onready var settings_menu: Panel = $SettingsMenu



func _ready() -> void:
		main_buttons.visible = true
		settings_menu.visible = false

var now_level = str(Global.level)
var next_file = "res://scenes/levels/level_"+ now_level +".tscn"
func _on_play_pressed() -> void:

	get_tree().change_scene_to_file(next_file)

func _on_settings_pressed() -> void:
	main_buttons.visible = false
	settings_menu.visible = true
	
func _on_exit_pressed() -> void:
	get_tree().quit()
	
	
#        --Settings menu--

func _on_back_button_pressed() -> void:
	main_buttons.visible = true
	settings_menu.visible = false
