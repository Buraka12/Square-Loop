extends Control

@onready var main_buttons: VBoxContainer = $Main_buttons
@onready var settings_menu: Panel = $SettingsMenu



func _ready() -> void:
	main_buttons.visible = true
	settings_menu.visible = false

	AudioManager.play("Main",0,true)

func _on_play_pressed() -> void:
	Global.CheckEntity_LevelChange()

func _on_settings_pressed() -> void:
	main_buttons.visible = false
	settings_menu.visible = true
	
func _on_exit_pressed() -> void:
	get_tree().quit()
	
	
#        --Settings menu--

func _on_back_button_pressed() -> void:
	main_buttons.visible = true
	settings_menu.visible = false
