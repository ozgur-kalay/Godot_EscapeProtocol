@tool
extends Area2D
class_name Interactable

# Adding shape Interaction:
# TODO: Collision shapes are now possible of multiple shapes. Change disabled enabled in code.
signal interaction_started_no_args
signal interaction_finished_no_args
# ====================== Area Signals ======================
## Emitted when a valid interaction begins using the selected InteractionKeys input.
signal interaction_started(_interactor: Interactor, _interation_key: InteractionsManager.InteractionKeys)
## Emitted when an active interaction ends.
signal interaction_finished(_interactor: Interactor)
## Emitted when an interactor attempts an interaction with an invalid or unsupported InteractionKeys input.
signal invalid_interactor(_interactor: Interactor, _interation_key: InteractionsManager.InteractionKeys)
## Emitted when an interactor enters the interaction area (Area2D-level detection).
signal interactor_contact_entered(_interactor: Interactor)
## Emitted when an interactor exits the interaction area (Area2D-level detection).
signal interactor_contact_exited(_interactor: Interactor)
# ===========================================================

## Defines which interaction input/action is required to trigger this component.
## Uses InteractionsManager.InteractionKeys enum to map to specific player inputs.
@export var interaction_key: InteractionsManager.InteractionKeys

@export var enabled: bool = true
## If true, signals are emitted using deferred calls.
## This avoids immediate execution during physics/processing steps and helps prevent modification errors.
@export var use_defered_signals: bool = true

var collision_shapes: Array[CollisionShape2D]
#var collision_shape: CollisionShape2D
var _default_process_mode: ProcessMode

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	for child in get_children():
		if child is CollisionShape2D:
			collision_shapes.append(child)
			
	if collision_shapes.is_empty():
		printerr(owner.name, "::", name, "::Has no collision shape!")
		return
	
	_default_process_mode = process_mode
	
	if enabled:
		enable()
	else:
		disable()

func interact(_interactor: Interactor, _interation_key: InteractionsManager.InteractionKeys) -> bool:
	var result: bool = false
	if interaction_key == _interation_key:
		result = true
		if use_defered_signals:
			call_deferred("_publish_deferred_interaction_started", _interactor, _interation_key)
		else:
			interaction_started.emit(_interactor, _interation_key)
	if !result:
		invalid_interactor.emit(_interactor, _interation_key)
	return result

func finish_interaction(interactor: Interactor) -> void:
	if use_defered_signals:
		call_deferred("_publish_deferred_interaction_finished", interactor)
	else:
		interaction_finished.emit(interactor)
	
func enable() -> void:
	for collision_shape in collision_shapes:
		collision_shape.set_deferred("disabled", false)
	enabled = true
	process_mode = _default_process_mode
	
func disable() -> void:
	for collision_shape in collision_shapes:
		collision_shape.set_deferred("disabled", true)
	enabled = false
	process_mode = Node.PROCESS_MODE_DISABLED

# ======== Defered Area Signal publishing ============
#func _publish_interactor_contact_deferred(_interactor: Interactor) -> void:
func _publish_deferred_interactor_contact_entered(interactor: Interactor) -> void:
	interactor_contact_entered.emit(interactor)

func _publish_deferred_interactor_contact_exited(interactor: Interactor) -> void:
	interactor_contact_exited.emit(interactor)

func _publish_deferred_interaction_started(interactor: Interactor, _interation_key: InteractionsManager.InteractionKeys) -> void:
	interaction_started.emit(interactor, _interation_key)
	interaction_started_no_args.emit()
	
func _publish_deferred_interaction_finished(interactor: Interactor) -> void:
	interaction_finished.emit(interactor)
	interaction_finished_no_args.emit()
# ================================================
