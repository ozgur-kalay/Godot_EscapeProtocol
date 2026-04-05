extends Node2DState

@onready var eye_sleep: Sprite2D = $"../../EyeSleep"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var pov_light: PointLight2D = $"../../POV_Light"
@onready var heart_light: PointLight2D = $"../../HEART_Light"

func enter_state(_args = null) -> void:
	if client.start_state == client.States.PATROL:
		parent.change_state("PatrolState")
		return
	
	eye_sleep.show()
	animation_player.stop()
	pov_light.enabled = false
	heart_light.enabled = false
	
	for ray_cast in client.ray_casts:
		ray_cast.enabled = false
	
func exit_state(_args = null) -> void:
	eye_sleep.hide()
	pov_light.enabled = true
	heart_light.enabled = true
	
func update(_delta: float) -> void:
	pass
