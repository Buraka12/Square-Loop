extends CharacterBody2D


var health : float = 100
const SPEED = 300.0

func die():
	queue_free()
