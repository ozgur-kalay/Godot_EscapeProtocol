extends Node2DState

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var eye_sprite: Sprite2D = $"../../EyeSprite"

func enter_state(_args = null) -> void:
	eye_sprite.show()
	animation_player.play("ray_cast_movement")
	for ray_cast in client.ray_casts:
		ray_cast.enabled = true
	
func exit_state(_args = null) -> void:
	pass

func update(_delta: float) -> void:
	client._patrol(_delta)
	client.search_target()
	if client.is_target_hit():
		parent.change_state("AttackState")
