extends Node

static var level :int = 11
static var entity :int = 0

static var first_time : bool = true

func CheckEntity_LevelChange():
	print(level)
	if entity == 0:
		level += 1
		var next_file : String
		if level >= 12:
			next_file = "res://scenes/Boss/boss_room.tscn"
		else:
			var now_level = str(level)
			next_file = "res://scenes/levels/level_"+ now_level +".tscn"
		get_tree().change_scene_to_file(next_file)
		
