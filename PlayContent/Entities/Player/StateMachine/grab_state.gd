extends Character2DState

@onready var grab_sub_state_machine: Character2DStateMachine = $GrabSubStateMachine

var dragable_normal: Vector2

const EXTRA_MARGIN: float = 10.0

func enter_state(_args = null) -> void:
	if _args:
		dragable_normal = _args
	else:
		parent.change_state("IdleState")
		return
	
	#print(name, "::dragable_normal = ", dragable_normal)
	var pos_off_set_x : float = (client.dragable.global_position.x) + ((client.dragable.min_distance_x + EXTRA_MARGIN) * dragable_normal.x)
	var pos_off_set_y : float = (client.dragable.global_position.y) + ((client.dragable.min_distance_y + EXTRA_MARGIN) * dragable_normal.y)
	
	if pos_off_set_x != 0:
		client.global_position.x = pos_off_set_x
	if pos_off_set_y != 0:
		client.global_position.y = pos_off_set_y
	client.play_main_animation("grab")
	
func exit_state(_args = null) -> void:
	pass

func update(_delta: float) -> void:
		
	if !Input.is_action_pressed("drag") or client.dragable == null:
		grab_sub_state_machine.disable()
		parent.change_state("IdleState")
		return
		
	if !grab_sub_state_machine.enabled and dragable_normal != Vector2.ZERO:
		grab_sub_state_machine.enable()
		grab_sub_state_machine.change_state("GrabSubState", dragable_normal)
		
	if grab_sub_state_machine.current_state.name != "GrabSubState":
		client.stamina_current -= client.stamina_drag_drain_rate
			
func _on_hurt_box_health_finished(_hurt_box: HurtBox, _hit_box: HitBox) -> void:
	grab_sub_state_machine.disable()
	client.stop_main_animation()
