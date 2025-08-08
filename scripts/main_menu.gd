extends Control

@onready var main_menu_buttons: VBoxContainer = $Main_buttons
@onready var settings_menu: Panel = $SettingsMenu


func _ready() -> void:
	main_menu_buttons.visible = true
	settings_menu.visible = false
	#Sesler başlar
	AudioManager.play("Main",0,true)

#Maın Menu Play Button
func _on_play_pressed() -> void:
	#Sonraki bölüme geçme kapalı.
	Global.next = false
	Global.CheckEntity_LevelChange()

#Setting Menu Button
func _on_settings_pressed() -> void:
	main_menu_buttons.visible = false
	settings_menu.visible = true

#Main Menu Exıt Button
func _on_exit_pressed() -> void:
	get_tree().quit()

#Setting Menu Back Button
func _on_back_button_pressed() -> void:
	main_menu_buttons.visible = true
	settings_menu.visible = false
