extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

@onready var _3: Sprite2D = $"../Level/3"

	
func _physics_process(delta: float) -> void:
	_3.position.x -= 3 * delta
