extends BaseLaserBeam
class_name ShootingLaserBeam

@onready var shoot_sfx: AudioGroup = $ShootSfx

var search: bool
var _target_is_hit: bool

# Called when the node enters the scene tree for the first time.
func _initialize() -> void:
	target_position = Vector2.ZERO
	extending_speed = 2000#1200
	
	default_target_pos = Vector2.ZERO
	default_begin_point = Vector2.ZERO
	default_end_point = Vector2.ZERO
	default_extend_direction = Vector2.ZERO
	hit_particles.one_shot = true

func _physics_process(_delta: float) -> void:
	if search:
		if is_colliding():
			var _collider: Object = get_collider()
			if _collider is HurtBox:
				_collider.take_damage(null, damage)
				_target_is_hit = true
				shoot_sfx.play()
				line_2d.points[1] = to_local(get_collision_point())

func extend_to(_caller: StringName, location: Vector2) -> void:
	#print(name, "::extend_to:: caller = ", _caller)
	#target_position = to_local(location)
	#target_position += target_position / 2
	target_position = to_local(location) * 1.5
	search = true
	#enable()
	
func is_target_hit() -> bool:
	return _target_is_hit

func scene_reset() -> void:
	super.scene_reset()
	_target_is_hit = false
