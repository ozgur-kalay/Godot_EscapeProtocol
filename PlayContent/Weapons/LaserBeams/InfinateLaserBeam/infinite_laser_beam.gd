@tool
extends BaseLaserBeam
class_name InfiniteLaserBeam

@onready var wall_detector: RayCast2D = $WallDetector
@onready var laser_diverter_interactor: Interactor = $LaserDiverterInteractor

var direction: Vector2

# Called when the node enters the scene tree for the first time.
func _initialize() -> void:
	line_2d.points[0] = Vector2.ZERO
	line_2d.points[1] = target_position
	
	default_target_pos = target_position
	default_begin_point = Vector2.ZERO
	default_end_point = target_position
	
	direction = target_position.normalized()
	
	wall_detector.target_position = direction * MAX_EXTEND
	
	extending_speed = 60
	
	var direction_to_core: Vector2 = hit_particles.position.direction_to(position)
	hit_particles.process_material.direction.x = direction_to_core.x
	hit_particles.process_material.direction.y = direction_to_core.y
	

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		line_2d.points[1] = target_position

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	#print(name, "::laser_diverter_interactor.position = ", laser_diverter_interactor.position)
	if !beam_enabled:
		return
	
	if wall_detector.is_colliding():
		#print(name, "::wall_detector colliding with = ", wall_detector.get_collider())
		target_position = to_local(wall_detector.get_collision_point())
		hit_particles.position = target_position
		hit_particles.emitting = true
		hit_particles_look_at(global_position)

	else:
		target_position = target_position.move_toward(wall_detector.target_position, extending_speed)
		hit_particles.emitting = false
	
	line_2d.points[1] = target_position
	laser_diverter_interactor.position = target_position
	
	if is_colliding():
		var _collider: Object = get_collider()
		if _collider is HurtBox:
			_collider.take_damage(null, damage)

func enable() -> void:
	super.enable()
	if Engine.is_editor_hint():
		return
	target_position = default_begin_point
	laser_diverter_interactor.position = Vector2.ZERO
	laser_diverter_interactor.enable()

func disable() -> void:
	super.disable()
	if Engine.is_editor_hint():
		return
	target_position = Vector2.ZERO
	line_2d.points[0] = default_begin_point
	line_2d.points[1] = default_end_point
	laser_diverter_interactor.position = Vector2.ZERO
	await get_tree().process_frame
	laser_diverter_interactor.disable()
