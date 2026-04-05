extends Node
class_name ZIndexModifierComponent

@export var z_index: ZIndexManager.ZIndexes

## Will self destroy after _ready().
@export var destroy_after_load: bool = true

func _ready() -> void:
	(get_parent() as CanvasItem).z_index = z_index
	if destroy_after_load:
		queue_free()
