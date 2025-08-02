extends CharacterBody2D

var health : int = 150

var times : Dictionary = {
	"Day":{"Rot":0,"Speed":TAU/5},
	"Hour":{"Rot":0,"Speed":TAU/2},
	"Minute":{"Rot":0,"Speed":TAU/1},
	"Second":{"Rot":0,"Speed":TAU/0.2}
}

func _process(delta: float) -> void:
	set_rot(delta)

func set_rot(delta):
	var keys = times.keys()
	for i in keys:
		var clock = find_child(i)
		
		times[i]["Rot"]+=times[i]["Speed"]*delta
		if times[i]["Rot"] >= TAU:
			times[i]["Rot"] = 0
		
		clock.rotation = times[i]["Rot"]
		pass

func die():
	health -= 1
	if health < 0:
		$AnimationPlayer.play("Dead")
		get_tree().change_scene_to_file("Son") 
