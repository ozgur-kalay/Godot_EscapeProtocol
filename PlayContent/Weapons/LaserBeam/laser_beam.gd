extends RayCast2D

@onready var line_2d: Line2D = $Line2D

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_colliding():
		var collider := get_collider()
		print(name, ": colliding with = ", collider.global_position)
