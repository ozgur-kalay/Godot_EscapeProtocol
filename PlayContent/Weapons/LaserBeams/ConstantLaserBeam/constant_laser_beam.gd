extends BaseLaserBeam
class_name ConstantLaserBeam

@onready var state_machine: RayCast2DStateMachine = $StateMachine


@export var max_length_x: float = 0 :
	get: return max_length_x
	set(val):
		max_length_x = val
		target_position.x = max_length_x
		
@export var max_length_y: float = 10000 :
	get: return max_length_y
	set(val):
		max_length_y = val
		target_position.y = max_length_y


# TODO: Implement on and off features
func scene_reset() -> void:
	pass
	
func enable() -> void:
	super.enable()
	if state_machine.initialized:
		state_machine.change_state("OnState")
	else:
		state_machine.set_entry_state(0)
	
func disable() -> void:
	super.disable()
	if state_machine.initialized:
		state_machine.change_state("OffState")
	else:
		state_machine.set_entry_state(1)
