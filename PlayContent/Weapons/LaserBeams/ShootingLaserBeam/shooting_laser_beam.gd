extends BaseLaserBeam
class_name ShootingLaserBeam

@onready var state_machine: RayCast2DStateMachine = $StateMachine

var is_shooting: bool

func _ready() -> void:
	target_position = Vector2(0, 10000)

func toggle_enable() -> void:
	is_shooting = !is_shooting

func scene_reset() -> void:
	state_machine.change_state("OffState")
	is_shooting = false

func enable() -> void:
	super.enable()
	is_shooting = true
	if state_machine.initialized:
		state_machine.change_state("ShootingState")
	else:
		state_machine.set_entry_state(1)
	
func disable() -> void:
	super.disable()
	is_shooting = false
	if state_machine.initialized:
		state_machine.change_state("OffState")
	else:
		state_machine.set_entry_state(0)
