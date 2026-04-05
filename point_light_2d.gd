extends PointLight2D

var default_scale: Vector2
var target_scale: Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	default_scale = scale
	target_scale = default_scale + Vector2(1.5, 1.5)
	var tween: Tween = create_tween()
	tween.set_loops()
	tween.tween_property(self, "scale", target_scale, 0.5)
	tween.tween_property(self, "scale", default_scale, 0.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
