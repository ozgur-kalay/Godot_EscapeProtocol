extends Node2DState
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"


func enter_state(_args = null) -> void:
	animation_player.stop()
	
func exit_state(_args = null) -> void:
	pass

func update(_delta: float) -> void:
	pass
