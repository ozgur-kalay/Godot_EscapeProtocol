extends Node2DState

func enter_state(_args = null) -> void:
	pass
	
func exit_state(_args = null) -> void:
	pass

func update(_delta: float) -> void:
	pass

func _on_door_interactable_interaction_started(_interactor: Interactor, _interation_key: int) -> void:
	if !is_active:
		return
	match client.lock_state:
		client.LockStates.Unlocked:
			parent.change_state("OpeningState")
			#print(name, ": Door UnLocked")
		client.LockStates.Locked:
			pass
			#print(name, ": Door Locked")
		client.LockStates.LowPowerLocked:
			parent.change_state("LowPowerState")
			#print(name, ": Door Locked Low Power")


	
