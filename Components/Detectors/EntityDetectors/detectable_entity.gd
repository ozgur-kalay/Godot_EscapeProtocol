@tool
extends Area2D
class_name DetectableEntity

func _enter_tree() -> void:
	collision_layer = 1 << 4
	collision_mask = 1 << 4

@export var client: Node2D

@export var default_detectability: int = 1
var current_detectability: int

@export var enabled_on_start: bool = true
var enabled: bool
var default_process_mode: ProcessMode

var collision_shape: CollisionShape2D
var default_shape_radius: float
var default_position: Vector2

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	for child in get_children():
		if child is CollisionShape2D:
			collision_shape = child
			default_shape_radius = collision_shape.shape.radius
	
	if !collision_shape:
		return
	
#	print(owner.name, "::", name, "::collision_shape.radius = ", collision_shape.shape.radius)
	default_process_mode = process_mode
	default_position = position
	current_detectability = default_detectability
	
	if enabled_on_start:
		enable()


func enable() -> void:
	
	enabled = true
	set_deferred("monitorable", true)
	set_deferred("monitoring", true)
	process_mode = default_process_mode

func disable() -> void:
	
	enabled = false
	set_deferred("monitorable", false)
	set_deferred("monitoring", false)
	process_mode = Node.PROCESS_MODE_DISABLED
	
func grow_shape(scaler: float) -> void:
	if collision_shape:
		reset_shape()
		collision_shape.shape.radius *= scaler

func reset_shape() -> void:
	
	if collision_shape:
		collision_shape.shape.radius = default_shape_radius

func look_left() -> void:
	look_at(global_position + Vector2.LEFT)
	position.x = -default_position.x
	
func look_right() -> void:
	look_at(global_position + Vector2.RIGHT)
	position.x = default_position.x
	
func look_up() -> void:
	look_at(global_position + Vector2.UP)
	position.y = -default_position.y
	
func look_down() -> void:
	look_at(global_position + Vector2.DOWN)
	position.y = default_position.y
