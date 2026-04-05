extends Node2D

signal wall_laser_enabled
signal wall_laser_disabled

@export var enabled: bool = true

@onready var infinate_laser_beam: InfiniteLaserBeam = $InfinateLaserBeam

func _ready() -> void:
	if enabled:
		enable()
	else:
		disable()

func enable() -> void:
	infinate_laser_beam.enable()
	wall_laser_enabled.emit()
	
func disable() -> void:
	infinate_laser_beam.disable()
	wall_laser_disabled.emit()
