extends CharacterBody2D

var direction : Vector2
var rot_speed : float = 700.0

@onready var main : Node2D = $".."
@onready var player: CharacterBody2D = main.find_child("Player")
@onready var agent: NavigationAgent2D = $NavigationAgent2D

enum states {MOVE,STOP}
var state : states

func _ready() -> void:
	Global.entity += 1
	state = states.MOVE

func _physics_process(delta: float) -> void:
	direction = (agent.get_next_path_position()-global_position).normalized()
	rotation_degrees+=delta*rot_speed

func die(_damage = 1):
	Global.entity -= 1
	Global.next = true
	Global.CheckEntity_LevelChange()
	call_deferred("queue_free")

func _on_hit_box_area_entered(area: Node2D) -> void:
	if area.name == "HurtBox":
		area.get_parent().die()


func _on_path_find_timer_timeout() -> void:
	agent.target_position = player.global_position
