extends Node

static var level :int = 1
static var entity :int = 0

#Boss İlk Defa mı Başlıyor?
static var first_time : bool = true

#Bölüm Başlıyor mu?
static var level_start : bool = true

#Sonraki Bölüme Geçilebilir mi?
static var next : bool = true
#Oyun Bitti mi?
static var end : bool = false

static  var music : float = 1
static  var sfx : float = 1

func CheckEntity_LevelChange():
	if entity == 0:
		level_start = false
		if next:
			level += 1
			level_start = true
		var next_scene : String
		#Level 12 Olduysa Boss Odasına Git
		if level >= 12:
			next_scene = "res://scenes/Boss/boss_room.tscn"
		else:
			var current_level = str(level)
			next_scene = "res://scenes/levels/level_" + current_level + ".tscn"
		
		# Deferred çağır, fizik sırasında değil
		call_deferred("_change_scene", next_scene)

# Bu fonksiyon fizik dışı bir anda çağrılır
func _change_scene(path: String) -> void:
	get_tree().change_scene_to_file(path)
		
