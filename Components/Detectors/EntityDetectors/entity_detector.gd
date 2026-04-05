@tool
extends Node2D
class_name EntityDetectorRayCast2DGroup

func _enter_tree() -> void:
	var has_raycast_2d_group: bool = false
	
	for child in get_children():
		if child is RayCast2DGroup:
			has_raycast_2d_group = true
			
	if !has_raycast_2d_group:
		var _area2d: RayCast2DGroup = RayCast2DGroup.new()
		add_child(_area2d, true)
		_area2d.owner = get_tree().edited_scene_root


@export var print_enter: bool = false
@export var print_exit: bool = false

signal detectable_detected(_detectable_entity: DetectableEntity, _detection_point: Vector2)

var ray_cast_2d_group: RayCast2DGroup

var default_process_mode: ProcessMode

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	var has_ray_cast_group: bool = false
	
	for child in get_children():
		if child is RayCast2DGroup:
			ray_cast_2d_group = child
			ray_cast_2d_group.enable()
			has_ray_cast_group = true
	
	if !has_ray_cast_group:
		printerr(owner.name, "::", name, "::Requires a RayCast2DGroupNode. ABORTING!")
	
	default_process_mode = process_mode

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	if ray_cast_2d_group:
		for ray in ray_cast_2d_group.rays:
			if ray.is_colliding():
				if ray.get_collider() is DetectableEntity:
					detectable_detected.emit(ray.get_collider(), ray.get_collision_point())
					ray_cast_2d_group.disable()

func enable() -> void:
	process_mode = default_process_mode

func disable() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED

func look_left() -> void:
	look_at(global_position + Vector2.LEFT)
	if ray_cast_2d_group:
		ray_cast_2d_group.look_left()
	
func look_right() -> void:
	look_at(global_position + Vector2.RIGHT)
	if ray_cast_2d_group:
		ray_cast_2d_group.look_right()
	
func look_up() -> void:
	look_at(global_position + Vector2.UP)
	if ray_cast_2d_group:
		ray_cast_2d_group.look_up()
	
func look_down() -> void:
	look_at(global_position + Vector2.DOWN)
	if ray_cast_2d_group:
		ray_cast_2d_group.look_down()
