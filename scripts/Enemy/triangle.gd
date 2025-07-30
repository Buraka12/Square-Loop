extends CharacterBody2D


var health : float = 100
@onready var health_bar: ProgressBar = $HealthBar
const SPEED = 300.0


func _physics_process(delta: float) -> void:
	if health <= 0:
		die()
	health_bar.value = health

func die():
	queue_free()
