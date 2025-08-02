extends CharacterBody2D

var health : int = 1

var bullet_scene : PackedScene = load("res://scenes/enemy_bullet.tscn")
var fire_rate : float = 6.0

@export var black : Color
@export var can_shoot : bool = true

var times : Dictionary = {
	"Day":{"Rot":0,"Speed":TAU/5},
	"Hour":{"Rot":0,"Speed":TAU/2},
	"Minute":{"Rot":0,"Speed":TAU/1},
	"Second":{"Rot":0,"Speed":TAU/0.2}
}

func _ready() -> void:
	var dur : int
	if Global.first_time:
		dur = 5
	else:
		dur = 1
	await get_tree().create_timer(dur).timeout
	$AnimationPlayer.play("Idle")

func _process(delta: float) -> void:
	if Global.end:
		return
	set_rot(delta)
	if can_shoot:
		can_shoot = false
		$Timer.start(1/fire_rate)
		fire()

func set_rot(delta):
	var keys = times.keys()
	for i in keys:
		var clock = find_child(i)
		
		times[i]["Rot"]+=times[i]["Speed"]*delta
		if times[i]["Rot"] >= TAU:
			times[i]["Rot"] = 0
		
		clock.rotation = times[i]["Rot"]
		pass

func fire():
	var bullet = bullet_scene.instantiate()
	bullet.SPEED = 250.0
	bullet.pos = Vector2(randi_range(0,1152),648)
	bullet.global_position = global_position
	$"..".add_child(bullet)

func die(damage = 1):
	if $"..".start:
		health -= damage
		print(health)
		if health<0:
			Global.end = true
			$"..".find_child("BossAnimations").play("End")
			$AnimationPlayer.play("Dead")
			var tween = create_tween()
			tween.tween_property($".","modulate",black,5)
			tween.finished.connect(func():
				$".".queue_free()
				$"..".find_child("BossAnimations").play("Door")
			)



func _on_timer_timeout() -> void:
	can_shoot = true
