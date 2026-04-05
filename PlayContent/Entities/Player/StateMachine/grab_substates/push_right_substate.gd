extends Character2DState

#PUSH RIGHT STATE

var dragable_normal: Vector2

func enter_state(_args = null) -> void:
	if !_args:
		printerr(client.name, "::", name, "::enter_state()::_args empty!")
		return
		
	client.look_at(client.global_position + Vector2.RIGHT)
	
	dragable_normal = _args
	client.play_main_animation("push")
	
func exit_state(_args = null) -> void:
	pass

func update(_delta: float) -> void:
	if !Input.is_action_pressed("drag") or client.input_vect.x == 0 or client.dragable == null:
		parent.change_state("GrabSubState", dragable_normal)
		return
	
	
	client.drag(Vector2.RIGHT)
