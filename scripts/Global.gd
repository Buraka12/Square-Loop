extends Node

static var level :int = 1
static var entity :int = 0

static var first_time : bool = true

static var next : bool = true
static var end : bool = false

static  var music : float = 1
static  var sfx : float = 1

func CheckEntity_LevelChange():
	if entity == 0:
		if next:
			level += 1
		var next_file : String
		if level >= 12:
			next_file = "res://scenes/Boss/boss_room.tscn"
		else:
			var now_level = str(level)
			next_file = "res://scenes/levels/level_"+ now_level +".tscn"
		get_tree().change_scene_to_file(next_file)
		
