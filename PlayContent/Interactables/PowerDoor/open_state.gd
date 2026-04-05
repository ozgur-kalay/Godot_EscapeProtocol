# open_state.gd
extends Node2DState

@onready var power_door_static: StaticBody2D = $"../../PowerDoorStatic"
@onready var interactable: Interactable = $"../../DoorInteractable"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

@onready var timer: Timer = $Timer

func enter_state(_args = null) -> void:
	timer.one_shot = true
	
func exit_state(_args = null) -> void:
	pass

func update(_delta: float) -> void:
	pass

func _on_door_interactable_interaction_started(_interactor: Interactor, _interation_key: int) -> void:
	if is_active:
		timer.stop()

func _on_door_interactable_interaction_finished(_interactor: Interactor) -> void:
	if !is_active:
		return
	timer.start()
	await timer.timeout
	parent.change_state("ClosingState")
