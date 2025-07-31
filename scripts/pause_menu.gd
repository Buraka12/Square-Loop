extends CanvasLayer

@onready var pause_menu: CanvasLayer = $"."

@onready var resume_button: Button = $blur/corner/VBoxContainer/HBoxContainer/resume_button
@onready var settings_button: Button = $blur/corner/VBoxContainer/HBoxContainer/settings_button
@onready var exit_button: Button = $blur/corner/VBoxContainer/HBoxContainer/exit_button

func _ready() -> void:
	pause_menu.visible = false
	resume_button.pressed.connect(unpause)
	exit_button.pressed.connect(get_tree().quit)
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		pause()
		
		
func unpause():
	pause_menu.visible = false
	get_tree().paused = false
	
func pause():
	pause_menu.visible = true
	get_tree().paused = true
	
	
