extends RigidBody2D

#Hedef Nokta
var pos : Vector2
var SPEED : float = 700.0
#Kaç saniye sonra yok olacak
var dur : float = 6.0
#Kaç saniyedir var
var time : float = 0.0

func _ready() -> void:
	#Başlangıç Yönü
	var direction = (pos - global_position).normalized()
	linear_velocity += direction * SPEED
	#Sprite'ı döndürme
	rotation = get_angle_to(pos) + PI/2


func _process(delta: float) -> void:
	#Süre Dolunca yok ol
	time+=delta
	var ratio = time/dur
	if ratio >= 1:
		queue_free()

#Bir varlığa çarparsa
func _on_hit_box_area_entered(area: Node2D) -> void:
	if area.name == "HurtBox":
		area.get_parent().die()
		queue_free()

#TileMap e çarparsa
func _on_hit_box_body_entered(body: Node2D) -> void:
	if body is TileMap:
		queue_free()
