# on_state.gd
extends RayCast2DState

@onready var hit_particles: GPUParticles2D = $"../../HitParticles"
@onready var line_2d: Line2D = $"../../Line2D"
@onready var hit_box: HitBox = $"../../HitBox"
@onready var laser_diverter_interactor: Interactor = $"../../LaserDiverterInteractor"

func enter_state(_args = null) -> void:
	client.enabled = true

func update(_delta: float) -> void:
	_initial_shoot()
	_check_hurt_box()

func _check_hurt_box() -> void:
	if client.is_colliding():
		var collider: = client.get_collider()
		if collider is HurtBox:
			print(name, ": hurtbox detected")
			hit_box.enable()
			hit_box.global_position = (client.get_collision_point())

# Particles
func _initial_shoot() -> void:
	var hit_point: Vector2
	
	if client.is_colliding():
		hit_point = client.get_collision_point()
		hit_particles.global_position = hit_point
		hit_particles.emitting = true
		laser_diverter_interactor.enable()
		laser_diverter_interactor.global_position = hit_point
	else:
		laser_diverter_interactor.disable()
		hit_point = client.to_global(client.target_position)
		hit_particles.global_position = hit_point
		hit_particles.emitting = false
		
# Line update
	var local_hit = client.to_local(hit_point)
	#client.target_position = local_hit
	line_2d.clear_points()
	line_2d.add_point(Vector2.ZERO)
	line_2d.add_point(local_hit)

func exit_state(_args = null) -> void:
	pass


func _on_laser_diverter_interactor_interaction_started(interactable: Interactable) -> void:
	print(client.name, ":", "_on_laser_diverter_interactor_interaction_started")
