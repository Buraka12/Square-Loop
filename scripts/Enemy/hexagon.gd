extends Enemy

#Dönme Hızı
var rot_speed : float = 700.0

func _ready() -> void:
	#Level ataması
	area = $".."
	player = area.find_child("Player")
	#Varlık sayısı arttırılır
	Global.entity += 1
	#Başlangıç için durum atanır
	state = states.MOVE

func _physics_process(delta: float) -> void:
	#Yön ataması
	change_dir(1)
	#Döndürme
	rotation_degrees+=delta*rot_speed

func _on_hit_box_area_entered(area2: Node2D) -> void:
	if area2.name == "HurtBox":
		area2.get_parent().die()

#PathFinderTimer
func _on_path_find_timer_timeout() -> void:
	#Belirli saniyede bir hedef konumu güncellenir
	agent.target_position = player.global_position
