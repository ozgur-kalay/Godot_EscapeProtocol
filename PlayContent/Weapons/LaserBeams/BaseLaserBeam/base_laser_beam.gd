extends RayCast2D
class_name BaseLaserBeam

signal laser_beam_enabled
signal laser_beam_disabled

@export var laser_enabled: bool = true:
	get: return laser_enabled
	set(val):
		laser_enabled = val

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	if laser_enabled:
		enable()
	else:
		disable()
		
			
func enable() -> void:
	enabled = true
	if !Engine.is_editor_hint():
		laser_beam_enabled.emit()
		
func disable() -> void:
	enabled = false
	if !Engine.is_editor_hint():
		laser_beam_disabled.emit()

# Virtual Functions

func scene_reset() -> void:
	pass
	
