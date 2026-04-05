extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var power_door_static: StaticBody2D = $PowerDoorStatic
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interactable: Interactable = $DoorInteractable

enum LockStates{Unlocked, Locked, LowPowerLocked}
@export var lock_state: LockStates = LockStates.Unlocked

enum DoorStates{Closed, Open}
var door_state: DoorStates = DoorStates.Closed

@onready var door_lamp: Sprite2D = $DoorLamp
@onready var door_lamp_2: Sprite2D = $DoorLamp2

@onready var node_2d_state_machine: Node2DStateMachine = $Node2DStateMachine

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	return
	#match lock_state:
		#LockStates.Unlocked:
			#_unlocked()
		#LockStates.Locked:
			#_locked()
		#LockStates.LowPowerLocked:
			#_low_power_locked()
#
#func _on_interactable_interaction_started(_interactor: Interactor, _interation_key: int) -> void:
	#power_door_static.process_mode = Node.PROCESS_MODE_DISABLED
	#animation_player.play("Door_Open")
#
#func _on_interactable_interaction_finished(_interactor: Interactor) -> void:
	#sprite_2d.show()
	#power_door_static.process_mode = Node.PROCESS_MODE_INHERIT
	#animation_player.play("Door_Close")
#
#func _locked() -> void:
	#lock_state = LockStates.Locked
	#door_lamp.locked_state()
	#door_lamp_2.locked_state()
	#interactable.disable()
#
#func _unlocked() -> void:
	#lock_state = LockStates.Unlocked
	#door_lamp.unlocked_state()
	#door_lamp_2.unlocked_state()
	#interactable.enable()
#
#func _low_power_locked() -> void:
	#lock_state = LockStates.LowPowerLocked
