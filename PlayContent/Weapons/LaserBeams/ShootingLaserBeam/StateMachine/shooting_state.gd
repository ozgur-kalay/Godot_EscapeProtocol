# bullet_shooting_state.gd
extends RayCast2DState

@onready var hit_particles: GPUParticles2D = $"../../HitParticles"
@onready var line_2d: Line2D = $"../../Line2D"
@onready var hit_box: HitBox = $"../../HitBox"

func enter_state(_args = null) -> void:
	client.enabled = true
	
func exit_state(_args = null) -> void:
	pass

func update(_delta: float) -> void:
	if client.is_shooting:
		_shoot()
		#_check_hurt_box()
	else:
		parent.change_state("OffState")

func _check_hurt_box() -> void:
	if client.is_colliding():
		var collider = client.get_collider()
		if collider is HurtBox:
			print(name, ": detected hurt box")

func _shoot() -> void:
	var hit_point: Vector2
	
	if client.is_colliding():
		hit_point = client.get_collision_point()
		hit_particles.global_position = hit_point
		hit_particles.emitting = true
		hit_box.global_position = hit_point
		hit_box.enable()
	else:
		hit_point = client.to_global(client.target_position)
		hit_particles.global_position = hit_point
		hit_particles.emitting = false
	
	
# Line update
	var local_hit = client.to_local(hit_point)
	line_2d.clear_points()
	line_2d.add_point(Vector2.ZERO)
	line_2d.add_point(local_hit)
