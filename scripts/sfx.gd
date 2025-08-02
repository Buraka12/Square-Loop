extends HSlider

@export var bus_name :String

var bus_id

func _ready() -> void:
	bus_id = AudioServer.get_bus_index(bus_name)

func _on_vfx_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_id,value)
