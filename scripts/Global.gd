extends Node

static var level :int = 1
var entity :int = 0




func CheckEntity_LevelChange():
	if entity == 0:
		level += 1
		var now_level = str(level)
		var next_file = "res://scenes/levels/level_"+ now_level +".tscn"
		get_tree().change_scene_to_file(next_file)
		
