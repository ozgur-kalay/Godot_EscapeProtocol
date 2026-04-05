extends Node2DState


@onready var entity_detector_ray_cast_2d_group: EntityDetectorRayCast2DGroup = $"../../EntityDetectorRayCast2DGroup"
@onready var pov_light: PointLight2D = $"../../POVLight"
@onready var sleep_sprite: Sprite2D = $"../../SleepSprite"

func enter_state(_args = null) -> void:
	if client.start_state == client.States.PATROL:
		parent.change_state("PatrolState")
		return
	sleep_sprite.show()
	
	entity_detector_ray_cast_2d_group.disable()
	pov_light.enabled = false

func exit_state(_args = null) -> void:
	sleep_sprite.hide()
	entity_detector_ray_cast_2d_group.enable()
	pov_light.enabled = true

func update(_delta: float) -> void:
	pass
