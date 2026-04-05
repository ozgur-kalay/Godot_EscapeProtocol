extends CharacterBody2D
class_name Dragable

var min_distance_x: float
var min_distance_y: float

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
#@onready var collision_shape_2d: CollisionShape2D = $Interactables/DragInteractable/CollisionShape2D

var starting_position: Vector2

func _ready() -> void:
	starting_position = global_position
	if collision_shape_2d.shape is RectangleShape2D:
		min_distance_x = collision_shape_2d.shape.size.x / 2
		min_distance_y = collision_shape_2d.shape.size.y / 2

func scene_reset() -> void:
	global_position = starting_position
