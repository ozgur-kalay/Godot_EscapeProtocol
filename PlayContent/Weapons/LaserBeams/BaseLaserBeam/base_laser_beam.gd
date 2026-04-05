extends RayCast2D
class_name BaseLaserBeam

signal beam_is_enabled
signal beam_is_disabled

## Use this to unable/disable the beam. It will override the raycast enable. Also has enable() disable().
@export var beam_enabled: bool = true :
	get: return beam_enabled
	set(value):
		beam_enabled = value
		if beam_enabled:
			enabled = true
			process_mode = Node.PROCESS_MODE_INHERIT
			call_deferred("publish_enabled")
			for child in get_children():
				if child is Line2D:
					child.show()
				if child is GPUParticles2D:
					child.show()
		else:
			enabled = false
			process_mode = Node.PROCESS_MODE_DISABLED
			call_deferred("publish_disabled")
			for child in get_children():
				if child is Line2D:
					child.hide()
				if child is GPUParticles2D:
					child.hide()


@onready var line_2d: Line2D = $Line2D
@onready var hit_particles: GPUParticles2D = $HitParticles

var default_process_mode: ProcessMode

# Used for look
var default_node_position: Vector2 = Vector2.ZERO

var default_target_pos: Vector2 = Vector2.ZERO
var default_begin_point: Vector2 = Vector2.ZERO
var default_end_point: Vector2 = Vector2.ZERO
var default_extend_direction: Vector2 = Vector2.ZERO

var extending: bool = false
var extending_direction: Vector2 = Vector2.ZERO
var extending_speed: float = 0

var damage: int = 1

const MAX_EXTEND: float = 2000

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	default_node_position = position
	default_process_mode = process_mode
	_initialize()
	
	if beam_enabled:
		enable()
	else:
		disable()

func hit_particles_look_at(target: Vector2) -> void:
	var direction_to_target: Vector2 = hit_particles.global_position.direction_to(target)
	hit_particles.process_material.direction.x = direction_to_target.x
	hit_particles.process_material.direction.y = direction_to_target.y

# _speed is used for the visual only
func extend(_direction: Vector2) -> void:
	extending = true
	extending_direction = _direction
	target_position = _direction * MAX_EXTEND
	enable()

func stop_extending() -> void:
	extending = false
	disable()

func scene_reset() -> void:
	#print(name, "::scene_reset")
	extending_direction = default_extend_direction
	target_position = default_target_pos
	line_2d.points[0] = default_begin_point
	line_2d.points[1] = default_end_point
	extending = false

func look_left() -> void:
	position.x = -default_node_position.x
	position.y = default_node_position.y
	
func look_right() -> void:
	position = default_node_position
	
func look_up() -> void:
	position.y = -default_node_position.x
	position.x = -default_node_position.y
	
func look_down() -> void:
	position.y = default_node_position.x
	position.x = -default_node_position.y

#  ============ Polymorphic functions ============
func _initialize() -> void:
	pass

func enable() -> void:
	enabled = true
	line_2d.show()
	hit_particles.show()
	call_deferred("publish_enabled")
	process_mode = default_process_mode

func disable() -> void:
	enabled = false
	line_2d.hide()
	hit_particles.hide()
	call_deferred("publish_disabled")
	process_mode = Node.PROCESS_MODE_DISABLED

func is_beam_enabled() -> bool:
	return beam_enabled

func publish_enabled() -> void:
	beam_is_enabled.emit()
	
func publish_disabled() -> void:
	beam_is_disabled.emit()
