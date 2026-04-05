extends Character2DState

var dragable_normal: Vector2

func enter_state(_args = null) -> void:
	if !_args:
		parent.change_state("IdleState")
		return
		
	dragable_normal = _args
	client.look_at(client.global_position + Vector2.UP)
	
	client.play_main_animation("pull")
	
func exit_state(_args = null) -> void:
	pass

func update(_delta: float) -> void:
	if !Input.is_action_pressed("drag") or client.input_vect.y == 0 or client.dragable == null:
		parent.change_state("GrabSubState", dragable_normal)
		return
		
	client.drag(Vector2.DOWN)
