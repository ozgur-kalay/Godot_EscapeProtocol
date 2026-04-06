# bullet_off_state.gd
extends RayCast2DState


@onready var hit_particles: GPUParticles2D = $"../../HitParticles"
@onready var line_2d: Line2D = $"../../Line2D"

func enter_state(_args = null) -> void:
	line_2d.points[1] = Vector2.ZERO
	hit_particles.emitting = false
	client.enabled = false
	
func update(_delta: float) -> void:
	if client.is_shooting:
		parent.change_state("ShootingState")
	
func exit_state(_args = null) -> void:
	pass
