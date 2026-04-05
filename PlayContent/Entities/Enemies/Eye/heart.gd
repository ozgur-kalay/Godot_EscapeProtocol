extends PointLight2D

var default_scale: Vector2
var target_scale: Vector2
var _pos_offset: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	default_scale = scale
	target_scale = Vector2(0.4, 0.4)
	var tween: Tween = create_tween()
	tween.set_loops()
	tween.tween_property(self, "scale", target_scale, 1)
	tween.tween_property(self, "scale", default_scale, 1)
	_pos_offset = position
