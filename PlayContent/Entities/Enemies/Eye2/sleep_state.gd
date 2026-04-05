extends Node2DState


@onready var pov_light: PointLight2D = $"../../POVLight"
@onready var sleep_sprite: Sprite2D = $"../../SleepSprite"

func enter_state(_args = null) -> void:
	if client.start_state == client.States.PATROL:
		parent.change_state("PatrolState")
		return
	sleep_sprite.show()
	
	
	pov_light.enabled = false
	
	
func exit_state(_args = null) -> void:
	sleep_sprite.hide()
	pov_light.enabled = true

func update(_delta: float) -> void:
	pass
