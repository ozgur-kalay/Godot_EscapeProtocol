extends Character2DState



var dragable_normal: Vector2

func enter_state(_args = null) -> void:
	if _args:
		dragable_normal = _args
	else:
		parent.disable()
		#parent.change_state("IdleState")
		return
	
	client.play_main_animation("grab")
	
func exit_state(_args = null) -> void:
	pass


func update(_delta: float) -> void:
	
	
	if !Input.is_action_pressed("drag") or client.dragable == null:
		parent.disable()
		return
	
	if dragable_normal != Vector2.ZERO:
		match dragable_normal:
			Vector2.LEFT:
				if (Input.is_action_pressed("right") and !Input.is_action_pressed("left")):
					parent.change_state("PushRightSubState", dragable_normal)
					
					return
				elif (Input.is_action_pressed("left") and !Input.is_action_pressed("right")):
					parent.change_state("PullLeftSubState", dragable_normal)
					
					return
			Vector2.RIGHT:
				if (Input.is_action_pressed("right") and !Input.is_action_pressed("left")):
					parent.change_state("PullRightSubState", dragable_normal)
					
					return
				elif (Input.is_action_pressed("left") and !Input.is_action_pressed("right")):
					parent.change_state("PushLeftSubState", dragable_normal)
					
					return
			Vector2.UP:
				client.global_position.x = client.dragable.global_position.x
				if (Input.is_action_pressed("down") and !Input.is_action_pressed("up")):
					parent.change_state("PushDownSubState", dragable_normal)
					
					return
				elif (Input.is_action_pressed("up") and !Input.is_action_pressed("down")):
					parent.change_state("PullUpSubState", dragable_normal)
					return
			Vector2.DOWN:
				client.global_position.x = client.dragable.global_position.x
				if (Input.is_action_pressed("up") and !Input.is_action_pressed("down")):
					parent.change_state("PushUpSubState", dragable_normal)
					return
				elif (Input.is_action_pressed("down") and !Input.is_action_pressed("up")):
					parent.change_state("PullDownSubState", dragable_normal)
					return
