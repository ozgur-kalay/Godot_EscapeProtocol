extends Node
class_name LightFlicker

@export_enum("ConstantFlicker", "Trigger") var mode: String = "ConstantFlicker"
@export var time: float
@export_range(0.0, 16.0) var strength_min: float = 1.0
@export_range(0.0, 16.0) var strength_max: float = 1.0

var client: PointLight2D 


func _ready() -> void:
	client = get_parent()
	#print(name, "::time = ", time)
	var tween: Tween = create_tween().set_loops()
	tween.tween_property(client, "energy", strength_min, time)
	tween.tween_property(client, "energy", strength_max, time)
