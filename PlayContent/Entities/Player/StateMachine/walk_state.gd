extends Character2DState


func enter_state(_args = null) -> void:
	client.play_main_animation("walk")

func exit_state(_args = null) -> void:
	client.stop_main_animation()

func update(_delta: float) -> void:	
	var input_vect: Vector2 = Input.get_vector("left", "right", "up", "down")
	var run_pressed: bool = Input.is_action_pressed("run")
	
	if (client.stamina_current < client.stamina_max):
		client.stamina_current += client.stamina_recovery_walk
		
	
	if (input_vect != Vector2.ZERO and run_pressed and client.stamina_current >= client.stamina_activate_threshold):
		parent.change_state("RunState")
		return
		
	if (input_vect == Vector2.ZERO):
		parent.change_state("IdleState")
		return
	

	client.move(client.walk_speed, client.input_vect, true)
	client.check_dragable()
