extends Node2DState

@onready var sprite_2d: Sprite2D = $"../../Sprite2D"

# Virtual methods
func enter_state(_args = null) -> void:
	sprite_2d.region_rect = client.off_state_sprite_region
	sprite_2d.modulate.v = client.off_state_sprite_v
	client.publish_off()
	
func exit_state(_args = null) -> void:
	pass

func update(_delta: float) -> void:
	pass

func _on_off_interactable_interaction_finished(_interactor: Interactor) -> void:
	if parent.current_state == self:
		parent.change_state("OnState")
