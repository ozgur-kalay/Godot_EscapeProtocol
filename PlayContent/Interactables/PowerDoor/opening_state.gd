extends Node2DState

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

func enter_state(_args = null) -> void:
	animation_player.play("Door_Open")
	await animation_player.animation_finished
	parent.change_state("OpenState")
	#print(name, ":animation finished")
	
	
func exit_state(_args = null) -> void:
	pass

func update(_delta: float) -> void:
	pass
