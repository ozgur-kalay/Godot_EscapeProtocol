extends Node2D

@onready var collision_shape_2d: CollisionPolygon2D = $"../CollisionShape2D"

@onready var top_ray: RayCast2D = $TopRay
@onready var bottom_ray: RayCast2D = $BottomRay

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if bottom_ray.is_colliding():
		collision_shape_2d.polygon[4] = to_local(bottom_ray.get_collision_point())
		collision_shape_2d.polygon[3].y = to_local(bottom_ray.get_collision_point()).y
		
	else:
		collision_shape_2d.polygon[4] = bottom_ray.target_position
		collision_shape_2d.polygon[3] = bottom_ray.target_position
