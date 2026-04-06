extends Node2D

@onready var shooting_laser_beam: ShootingLaserBeam = $ShootingLaserBeam
@onready var constant_laser_beam: ConstantLaserBeam = $"../../ConstantLaserBeam"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_select"):
		shooting_laser_beam.toggle_enable()
