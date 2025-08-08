extends CanvasLayer

@onready var pause_menu: CanvasLayer = $"."

@onready var resume_button: Button = $blur/corner/VBoxContainer/HBoxContainer/resume_button
@onready var main_menu: Button = $"blur/corner/VBoxContainer/HBoxContainer/main menu"
@onready var settings_button: Button = $blur/corner/VBoxContainer/HBoxContainer/settings_button
@onready var exit_button: Button = $blur/corner/VBoxContainer/HBoxContainer/exit_button

@onready var settings_menu: Panel = $SettingsMenu

func _ready() -> void:
	settings_menu.visible = false
	pause_menu.visible = false
	#Fonksiyonlar Butonlara bağlanır.
	resume_button.pressed.connect(unpause)
	main_menu.pressed.connect(returnMainMenu)
	exit_button.pressed.connect(get_tree().quit)

#Main Menu Button
func returnMainMenu():
	Global.entity = 0
	Global.next = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

#Pause Menu kapatma.
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		pause()

#Oyun devam eder.
func unpause():
	pause_menu.visible = false
	get_tree().paused = false

#Oyun durdurulur.
func pause():
	if !get_tree().paused:
		pause_menu.visible = true
		get_tree().paused = true

#Settings Button
func _on_settings_pressed() -> void:
	settings_menu.visible = true
