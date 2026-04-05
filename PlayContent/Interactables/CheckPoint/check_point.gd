extends Node2D
class_name CheckPoint

@onready var interactable: Interactable = $Interactable
@onready var sprite_2d: Sprite2D = $Sprite2D



func _on_interactable_interaction_started(_interactor: Interactor, _interation_key: int) -> void:
	interactable.disable()
	sprite_2d.modulate = Color.WEB_GREEN
	sprite_2d.modulate.v = 3.0
