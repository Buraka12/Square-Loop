class_name Key_bind
extends Control

@onready var label: Label = $HBoxContainer/Label
@onready var button: Button = $HBoxContainer/Button

@export var action_name : String = "right"


func  _ready() -> void:
	set_process_unhandled_key_input(false)
	set_action_name()
	set_text_for_key()
	
func set_action_name() -> void:
	label.text = "Unassigned"
	
	match  action_name:
		"left":
			label.text = "Move Left"
		"right":
			label.text = "Move Right"
		"up":
			label.text = "Move Up"
		"down":
			label.text = "Move Down"
		"dodge":
			label.text = "Use Dodge"
		"fire":
			label.text = "Use Fire"

		
func set_text_for_key() -> void:
	var action_events = InputMap.action_get_events(action_name)
	if action_events.size() > 0:
		var action_event = action_events[0]
		if action_event is InputEventKey:
			var action_keycode = OS.get_keycode_string(action_event.physical_keycode)
			button.text = "%s" % action_keycode
		elif action_event is InputEventMouseButton:
			button.text = "Mouse Button %d" % action_event.button_index
		else:
			button.text = "Unsupported Input"
	else:
		button.text = "No Input Event"
		

func _on_button_toggled(button_pressed) -> void:
	if button_pressed :
		button.text ="Press any key"
		set_process_unhandled_key_input(button_pressed)
		
		for i in get_tree().get_nodes_in_group("hotkey"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = false
				i.set_process_unhandled_key_input(false)
				
	else:
		
		for i in get_tree().get_nodes_in_group("hotkey"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = true
				i.set_process_unhandled_key_input(false)
		set_text_for_key()
	
func _unhandled_key_input(event):
	rebind_action_key(event)
	button.button_pressed = false
	
func rebind_action_key(event) -> void:
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name,event)
	
	set_process_unhandled_key_input(false)
	set_text_for_key()
	set_action_name()
