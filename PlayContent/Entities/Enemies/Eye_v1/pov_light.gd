extends PointLight2D

var _pos_offset: Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_pos_offset = position
	

func look_left() -> void:
	position.x = _pos_offset.x * -1
	position.y = _pos_offset.y
	look_at(global_position + Vector2.LEFT)
	
func look_right() -> void:
	position = _pos_offset
	look_at(global_position + Vector2.RIGHT)
	
func look_up() -> void:
	position.x = 0
	position.y = _pos_offset.x * -1 # Here x is used to determin the offset for the y component of position
	look_at(global_position + Vector2.UP)
	
func look_down() -> void:
	position.x = 0
	position.y = _pos_offset.x # Here x is used to determin the offset for the y component of position
	look_at(global_position + Vector2.DOWN)
