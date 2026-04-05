extends Node2D

@export var enable_on_start: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if enable_on_start:
		show()
