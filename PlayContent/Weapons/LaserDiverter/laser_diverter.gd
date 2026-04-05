@tool
extends Dragable
class_name LaserDiverter

@export_enum("0", "90", "180", "270") var rotation_angle: String = "0":
	get: return rotation_angle
	set(value):
		rotation_angle = value
		for child in get_children():
			if child.name == "LaserLine":
				match rotation_angle:
					"0":
						child.rotation = deg_to_rad(0) 
					"90":
						child.rotation = deg_to_rad(90)
					"180":
						child.rotation = deg_to_rad(180)
					"270":
						child.rotation = deg_to_rad(270)

@onready var infinate_laser_beam: InfiniteLaserBeam = $LaserLine/InfinateLaserBeam
@onready var infinate_laser_beam_2: InfiniteLaserBeam = $LaserLine/InfinateLaserBeam2

var enabled: bool

@onready var laser_line: Sprite2D = $LaserLine
var laser_line_default_color: Color

	
func _ready() -> void:
	super._ready()
	if Engine.is_editor_hint():
		return
	laser_line_default_color = laser_line.self_modulate
	
# ================ Beam 1 ================ 
func _on_interactable_interaction_started(_interactor: Interactor, _interation_key: int) -> void:
	if Engine.is_editor_hint():
		return
	infinate_laser_beam.enable()
	laser_line.self_modulate.v = 8.0

func _on_interactable_interaction_finished(_interactor: Interactor) -> void:
	if Engine.is_editor_hint():
		return
	infinate_laser_beam.disable()
	laser_line.self_modulate = laser_line_default_color


# ================ Beam 2 ================ 
func _on_interactable_2_interaction_started(_interactor: Interactor, _interation_key: int) -> void:
	if Engine.is_editor_hint():
		return
	infinate_laser_beam_2.enable()
	laser_line.self_modulate.v = 8.0


func _on_interactable_2_interaction_finished(_interactor: Interactor) -> void:
	if Engine.is_editor_hint():
		return
	infinate_laser_beam_2.disable()
	laser_line.self_modulate = laser_line_default_color
