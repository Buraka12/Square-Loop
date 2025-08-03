extends CanvasLayer

@onready var next_button: Button = $win/corner/VBoxContainer/HBoxContainer/next_level_button
@onready var main_menu: Button = $"win/corner/VBoxContainer/HBoxContainer/main menu"
@onready var exit_button: Button = $win/corner/VBoxContainer/HBoxContainer/exit_button
@onready var label: Label = $win/corner/VBoxContainer/label
@onready var win: Panel = $win

@onready var start: Panel = $start

var win_messages = [
	"You won? Must be your 
	lucky day.",
	"Congrats... I guess.",
	"Victory achieved. Somehow.",
	"Nice job pressing buttons 
	in the right order.",
	"Wow, you did it. The world 
	is truly changed.",
	"You win. Now go outside maybe?",
	"You beat the game. Still 
	unemployed though.",
	"Amazing. Truly. Now try 
	doing your laundry.",
	"You won! And it only took 
	a hundred tries.",
	"Impressive. For someone with 
	no social life.",
	"Glorious victory. Your parents 
	must be thrilled.",
	"You win! Somewhere, a 
	potato is proud.",
	"You did it! Now delete 
	the game forever.",
	"You won. Now what? Existential 
	crisis unlocked.",
	"Victory. Finally. It was 
	painful for us too."
]

func _ready() -> void:
	if Global.level < 12 and Global.level_start:
		get_tree().paused = true
		randomize()
		show_game_over_message()
		if Global.next == true:
			win.visible = true
		next_button.pressed.connect(next)
		main_menu.pressed.connect(returnMainMenu)
		exit_button.pressed.connect(get_tree().quit)
	
func returnMainMenu():
	Global.entity = 0
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	

func next():
	get_tree().paused = true
	win.visible = false
	$AnimationPlayer.play("level_start")
	await get_tree().create_timer(3).timeout
	start.visible = false
	get_tree().paused = false
	
	
	
func get_random_message() -> String:
	return win_messages[randi()%win_messages.size()]

func show_game_over_message():
	label.text = get_random_message()
	label.show()
