@tool
extends Area2D
class_name Interactor

signal interaction_started(interactable: Interactable)
signal interaction_finished(interactable: Interactable)
signal invalid_interactable(interactable: Interactable)

@export var interaction_keys: Array[InteractionsManager.InteractionKeys]
@export var enabled: bool = true
#@export var delayed_initialize: bool = true
var collision_shape: CollisionShape2D
var _default_process_mode: ProcessMode
var valid_interaction_found: bool
var interactable: Interactable

@export_category("Debug")
@export var print_enabled: bool = false
@export var print_disabled: bool = false
@export var print_interaction_finished: bool = false

func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	for child in get_children():
		if child is CollisionShape2D:
			collision_shape = child
			
	if collision_shape == null:
		printerr(owner.name, "::", name, "::Has no collision shape!")
		return
	
	_default_process_mode = process_mode
	
	#if delayed_initialize:
		#await get_tree().process_frame
	
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	
	if enabled:
		enable()
	else : disable()

func _on_area_entered(area: Area2D) -> void:
	if Engine.is_editor_hint():
		return
	
	if !enabled:
		return
	
	if area is Interactable:
		for key in interaction_keys:
			if area.interact(self, key):
				interaction_started.emit(area)
				interactable = area
				#print(name, ": interaction started")
				return
		
		invalid_interactable.emit(area)
		#print(name, ": invalid interactable")

func _on_area_exited(area: Area2D) -> void:
	if Engine.is_editor_hint():
		return
	if !enabled:
		return
	if area == interactable:
		if print_interaction_finished:
			print(owner.name, ":", name, ":interaction finished")
		(area as Interactable).finish_interaction(self)
		interaction_finished.emit(area)
		valid_interaction_found = false
		

func scene_reset() -> void:
	pass

func enable() -> void:
	if print_enabled:
		print(owner.name, ":", name, ": enable()")
	collision_shape.set_deferred("disabled", false)
	enabled = true
	process_mode = _default_process_mode
	
func disable() -> void:
	if print_disabled:
		print(owner.name, ":", name, ": disable()")
	collision_shape.set_deferred("disabled", true)
	enabled = false
	process_mode = Node.PROCESS_MODE_DISABLED
