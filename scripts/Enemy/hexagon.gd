extends CharacterBody2D

var speed = 100
var player_chase = false
@onready var player: CharacterBody2D = $"."


func _physics_process(delta: float) -> void:
	if player_chase:
		var direction = (player.position - position).normalized()
		velocity = direction*speed
		look_at(player.position)
		move_and_slide()
		

func _on_detection_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true


func _on_detection_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false
