extends Node2DState

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

func enter_state(_args = null) -> void:
	animation_player.play("Door_Close")
	parent.change_state("ClosedState")
	#await animation_player.animation_finished
	
func exit_state(_args = null) -> void:
	pass

func update(_delta: float) -> void:
	pass
		
