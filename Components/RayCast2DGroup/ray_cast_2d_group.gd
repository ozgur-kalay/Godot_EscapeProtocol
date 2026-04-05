@tool
extends Node2D
class_name RayCast2DGroup

enum ActiveStates{ENABLED, DISABLED}
@export var active_state: ActiveStates
@export_flags_2d_physics var collision_mask

var rays: Array[RayCast2D]
var default_target_positions: PackedVector2Array
var default_look: Vector2
var default_state: ActiveStates

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	for child in get_children():
		if child is RayCast2D:
			child.collision_mask = collision_mask
			rays.append(child)
			default_target_positions.append(child.target_position)
	
	
	default_state = active_state
	
	if active_state == ActiveStates.ENABLED:
		enable()
	else:
		disable()
	
	add_to_group("scene_reset")

func enable() -> void:
	active_state = ActiveStates.ENABLED
	for ray in rays:
		ray.enabled = true

func disable() -> void:
	active_state = ActiveStates.DISABLED
	for ray in rays:
		ray.enabled = false

func get_rays() -> Array[RayCast2D]:
	return rays

func reset() -> void:
	active_state = ActiveStates.DISABLED
	rotation = 0
	for i in range(0, rays.size()):
		rays[i].target_position = default_target_positions[i]
		rays[i].enabled = false

func scene_reset() -> void:
	active_state = default_state
	rotation = 0
	for i in range(0, rays.size()):
		rays[i].target_position = default_target_positions[i]
		match default_state:
			ActiveStates.ENABLED:
				rays[i].enabled = true
			ActiveStates.DISABLED:
				rays[i].enabled = false

func look_left() -> void:
	look_at(global_position + Vector2.LEFT)
	
func look_right() -> void:
	look_at(global_position + Vector2.RIGHT)
	
func look_up() -> void:
	look_at(global_position + Vector2.UP)	

func look_down() -> void:	
	look_at(global_position + Vector2.DOWN)
