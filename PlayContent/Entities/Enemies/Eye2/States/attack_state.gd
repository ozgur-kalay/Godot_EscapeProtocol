extends Node2DState

var laser_hit_sucess: bool
@onready var shooting_laser_beam: ShootingLaserBeam = $"../../ShootingLaserBeam"

func enter_state(_args = null) -> void:
	shooting_laser_beam.extend_to(owner.name + "::" + name, _args)
	
func exit_state(_args = null) -> void:
	pass

func update(_delta: float) -> void:
	pass
