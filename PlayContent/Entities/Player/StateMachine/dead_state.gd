extends Character2DState

@onready var hurt_box: HurtBox = $"../../../HurtBox"

var default_modulate: Color

func enter_state(_args = null) -> void:
	default_modulate = client.modulate
	client.modulate = client.dead_modulation
	
	hurt_box.disable()
	
	await get_tree().create_timer(1).timeout
	client.global_position = client.spawn_position
	parent.change_state("IdleState")
	SceneManager.current_scene.scene.report_player_dead()
	get_tree().paused = false
	
	
func exit_state(_args = null) -> void:
	client.modulate = default_modulate
	hurt_box.enable()

func update(_delta: float) -> void:
	pass
