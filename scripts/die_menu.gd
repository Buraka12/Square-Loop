extends CanvasLayer

@onready var die_menu: CanvasLayer = $"."

@onready var restart_button: Button = $blur/corner/VBoxContainer/HBoxContainer/restart_button
@onready var main_menu: Button = $"blur/corner/VBoxContainer/HBoxContainer/main menu"
@onready var exit_button: Button = $blur/corner/VBoxContainer/HBoxContainer/exit_button
@onready var label: Label = $blur/corner/VBoxContainer/label

var death_messages = [
	"You died. Pathetic.",
	"That was embarrassing.",
	"Seriously? That’s how you die?",
	"Try harder... or maybe don’t.",
	"You call that playing?",
	"Dead again? What 
	a surprise.",
	"You lasted five seconds.
	 Impressive. Not.",
	"Failure suits you.",
	"Loop broken... by your
	incompetence.",
	"Respawn and disappoint
	me again.",
	"Even a potato would've 
	survived longer.",
	"You're really good at dying.",
	"You died. Again. Shocking.",
	"Keep going... maybe you'll 
	improve. Maybe.",
	"Death seems to like you.",
	"Were you even trying?",
	"That was painful to watch.",
	"You're a natural-born loser.",
	"Game over. What a clown show.",
	"Bravo. You managed to fail."
]

func _ready() -> void:
	randomize()
	die_menu.visible = false
	restart_button.pressed.connect(restart)
	main_menu.pressed.connect(returnMainMenu)
	exit_button.pressed.connect(get_tree().quit)
	
func returnMainMenu():
	Global.entity = 0
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func restart():
	Global.entity = 0
	Global.CheckEntity_LevelChange()
	
func get_random_message() -> String:
	return death_messages[randi()%death_messages.size()]

func show_game_over_message():
	label.text = get_random_message()
	label.show()
