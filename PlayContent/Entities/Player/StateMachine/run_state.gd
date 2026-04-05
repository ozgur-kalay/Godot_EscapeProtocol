extends Character2DState

func enter_state(_args = null) -> void:
	if client.stamina_current < client.stamina_activate_threshold:
		parent.change_to_previous_state()
		return
	client.play_main_animation("run")
	
func exit_state(_args = null) -> void:
	client.stop_main_animation()

func update(_delta: float) -> void:
	var input_vect: Vector2 = Input.get_vector("left", "right", "up", "down")
	
	if (Input.is_action_just_released("run") or client.stamina_current <= 0):
		parent.change_state("WalkState")
		return
		
	if (input_vect == Vector2.ZERO):
		parent.change_state("IdleState")
		return
	
	client.move(client.run_speed, client.input_vect, true)
	client.check_dragable()
	
	if (client.global_position - client.previous_position != Vector2.ZERO):
		client.stamina_current -= client.stamina_drain_rate
		
