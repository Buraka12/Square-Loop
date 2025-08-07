extends Panel

@onready var settings_menu: Panel = $"."

#Ayarlar kapanır.
func _on_back_button_pressed() -> void:
	settings_menu.visible = false
