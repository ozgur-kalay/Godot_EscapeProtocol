extends Node2DState

@onready var ray_cast_2d: RayCast2D = $"../../RayCast2D"

func enter_state(_args = null) -> void:
	pass
	
func exit_state(_args = null) -> void:
	pass

func update(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if client.patrol_points.is_empty():
		return
	
	var direction = client.current_destination - client.global_position
	if direction.x > 0:
		client.look_right()
	elif direction.x < 0:
		client.look_left()
	elif direction.y < 0:
		client.look_up()
	elif direction.y > 0:
		client.look_down()
		
	client._patrol(_delta)
	
	if ray_cast_2d.is_colliding():
		var collider = ray_cast_2d.get_collider()
		print(collider)
