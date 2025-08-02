extends Node

static var level :int = 0
static var entity :int = 0


func CheckEntity_LevelChange():
	if entity == 0:
		print(level)
		level += 1
		var next_file : String
		if level >= 12:
			next_file = "res://scenes/Boss/boss_room.tscn"
		else:
			print("Burda")
			var now_level = str(level)
			next_file = "res://scenes/levels/level_"+ now_level +".tscn"
		get_tree().change_scene_to_file(next_file)
		
