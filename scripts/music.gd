extends HSlider

@export var bus_name :String

var bus_id

func _ready() -> void:
	bus_id = AudioServer.get_bus_index(bus_name)
	value = Global.music

func _on_value_changed(dvalue: float) -> void:
	Global.music = dvalue
	var db = linear_to_db(dvalue)
	AudioServer.set_bus_volume_db(bus_id,db)
