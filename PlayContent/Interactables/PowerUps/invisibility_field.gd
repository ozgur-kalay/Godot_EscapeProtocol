extends Node2D
class_name InvisibilityField

@onready var pass_through_sfx_group: AudioGroup = $PassThroughSFX_Group

@onready var point_light_2d: PointLight2D = $PointLight2D

@onready var interactable: Interactable = $InvisibilityInteractable

func _on_interactable_interaction_started(interactor: Interactor, _interation_key: int) -> void:
	if interactor.owner is Player:
		pass_through_sfx_group.play()
		point_light_2d.hide()
		interactable.disable()
		await get_tree().create_timer(3).timeout
		point_light_2d.show()
		interactable.enable()
