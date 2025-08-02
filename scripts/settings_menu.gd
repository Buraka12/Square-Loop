extends Panel

@onready var settings_menu: Panel = $"."
@onready var main_buttons: VBoxContainer = $"../Main_buttons"
@onready var music: HSlider = $TabContainer/Sounds/MarginContainer/VBoxContainer/music_container/music



func _on_back_button_pressed() -> void:
	settings_menu.visible = false
	main_buttons.visible = true
