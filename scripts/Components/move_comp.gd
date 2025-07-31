extends Node2D

@onready var parent : CharacterBody2D = $".."

@export var max_speed : float = 300.0
@export var SPEED : float = 0.0
@export var start_speed : float = 0.0
@export var clutch : float = 200.0

func _physics_process(delta: float) -> void:
	var direction = parent.direction
	if parent.state == parent.states.MOVE:
		follow_player(delta,direction)
	elif parent.state == parent.states.STOP:
		parent.velocity = Vector2(0,0)
		SPEED = start_speed
	parent.move_and_slide()

func follow_player(delta,direction):
	SPEED += clutch*delta
	if SPEED <= max_speed:
		parent.velocity = direction.normalized()*SPEED
	else:
		parent.velocity = direction.normalized()*max_speed
