extends Node2DState

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

func _on_entity_detector_detectable_detected(_detectable_entity: DetectableEntity, _detection_point: Vector2) -> void:
	if parent.current_state == self:
		parent.change_state("AttackState", _detection_point)
