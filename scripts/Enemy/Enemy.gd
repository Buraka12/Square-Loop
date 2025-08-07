extends CharacterBody2D

#Class adı
class_name Enemy

@export var anim : AnimationPlayer
@export var shoot_timer : Timer

#Yol bulucu(PathFinder)
@onready var agent : NavigationAgent2D = $NavigationAgent2D

var player : CharacterBody2D

#Bölüm(Level)
var area : Node2D

@onready var bulletscene : PackedScene = load("res://scenes/enemy_bullet.tscn")

var can_shoot : bool = false
var fire_rate : float = 0.6
#Geri tepme
var tab : float = 400.0

#Yön
var direction : Vector2

enum states {STOP,MOVE,FIRE}
var state : states

#Yön atama
func change_dir(dir):
	#dir düşman oyuncuya gidecek ise 1 kaçacak ise zıt yönde yani -1 olarak ayarlanır.
	direction = dir*(agent.get_next_path_position()-global_position).normalized()

#Oyuncuya doğru bakar.
func look_at_player():
	#Oyuncuya Döner
	look_at(player.global_position)
	#Sprite'dan kaynaklı 90 derece daha dönmesi gerekiyor.
	rotation_degrees += 90

#Ölme
func die(_damage = 1):
	#damage düşmanın aldığı hasar. Bu kısımda önemi yoktur. 
	#Toplam Varlık Sayısı Azalır.
	Global.entity -= 1
	#Diğer bölüme geçmek için izin verilir.
	Global.next = true
	#Yok olur.
	call_deferred("queue_free")
	#Sonraki bölüme geçebilir mi kontrol edilir.
	Global.CheckEntity_LevelChange()

#Sıkma sıklığına rastgele bir zaman atama
func random_dur():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var wait_time = rng.randf_range(0.5, 1.0)
	shoot_timer.start(wait_time/fire_rate)

#Ateş Etme
func fire(id:int):
	#id hangi düşman olduğunu betimler. 0:Üçgen,1:Beşgen,2:Yedigen
	#Altıgen ateş etmediği için altıgende kullanılmaz.
	#Ateş Edemez hale gelir.
	can_shoot = false
	#Hangi düşman olduğuna göre sıkma yolu
	match id:
		#Üçgen
		0:
			var bullet = bulletscene.instantiate()
			bullet.pos = player.global_position
			bullet.global_position = $Marker2D.global_position
			AudioManager.play("Shoot_Triangle")
			area.add_child(bullet)
		#Beşgen
		1:
			var offsets = [-16, 0, 16]
			var dist = Vector2(-direction.y, direction.x)
			var a : int = 0
			for i in $Points.get_children():
				var bullet = bulletscene.instantiate()
				bullet.pos = player.global_position + dist * offsets[a]
				bullet.global_position = i.global_position
				area.add_child(bullet)
				a+=1
				AudioManager.play("Shoot_Pentagon")
		#Yedigen
		2:
			state = states.FIRE
			shoot_timer.start(1)
	
	#Sıkma Animasyonu Oynar
	anim.play("Shoot")
