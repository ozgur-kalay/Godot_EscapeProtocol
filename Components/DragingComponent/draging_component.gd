extends Area2D
class_name DragingComponent

# Usage: Do not off set the draging component. Offset only the collision shape. Keep the dragning component in the center of the parent node.


@export var enabled: bool = false
var drag_client: Node2D = null
var dir_to_client: Vector2 = Vector2.ZERO

var _initial_dir_to_marker: Vector2

@onready var marker_2d: Marker2D = $Marker2D

var collision_shape: CollisionShape2D

var print_header: String

func _ready() -> void:
	print_header = owner.name + ":" + name + ":"
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	
	for child in get_children():
		if child is CollisionShape2D:
			collision_shape = child
			
	if !collision_shape:
		disable()
		printerr(print_header, ": ERROR : Has no collision shape! Disabled")
	
	if enabled: enable() 
	else: disable()
	
func _on_area_entered(dragable_component: DragableComponent) -> void:
	if !_is_marker_alinged():
		return
		
	drag_client = dragable_component.client
	dir_to_client = drag_client.global_position - global_position
	_initial_dir_to_marker = global_position.direction_to(marker_2d.global_position).normalized()
	_initial_dir_to_marker = _flatten_vector(_initial_dir_to_marker)
	print(print_header, "_initial_dir_to_marker = ", _initial_dir_to_marker)
	
func _on_area_exited(_dragable_component: DragableComponent) -> void:
	drag_client = null

func _flatten_vector(v: Vector2) -> Vector2:
	if v.x == 1.0 or v.x == -1.0:v.y = 0
	elif v.y == 1.0 or v.y == -1.0:v.x = 0
	return v

func _is_marker_alinged() -> bool:
	var _dir_to_marker: Vector2 = (global_position.direction_to(marker_2d.global_position)).normalized()
	if _dir_to_marker.x == 1.0:		return true
	elif _dir_to_marker.x == -1.0:	return true
	elif _dir_to_marker.y == 1.0:	return true
	elif _dir_to_marker.y == -1.0:	return true
	return false

func _is_marker_still_alinged() -> bool:
	# When the player changes direction the drag continoues for a few frames causing undisired movement to DragableComponent.
	# This fixes that by making sure that the player faces the same direction as it was initialially detected.
	var _current_dir_to_marker: Vector2 = _flatten_vector(global_position.direction_to(marker_2d.global_position)) 
	if _current_dir_to_marker != _initial_dir_to_marker:
		return false
	return true

func _physics_process(_delta: float) -> void:
	_drag()

func _drag() -> void:
	if !enabled:
		return
	if !_is_marker_alinged() :
		return
	if !drag_client:
		return
	if !_is_marker_still_alinged():
		return
		
	drag_client.global_position = global_position + dir_to_client

func enable() -> void:
	#print(print_header, " enable()")
	enabled = true
	collision_shape.set_deferred("disabled", false)

func disable() -> void:
	#print(print_header, " disable()")
	enabled = false
	drag_client = null
	collision_shape.set_deferred("disabled", true)
