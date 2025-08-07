extends Panel

@onready var settings_menu: Panel = $"."
@onready var main_buttons: VBoxContainer = $"../Main_buttons"

#Ayarlar Kapanır.
func _on_back_button_pressed() -> void:
	settings_menu.visible = false
	main_buttons.visible = true
