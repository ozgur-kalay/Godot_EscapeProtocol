extends Control

# This scene has no functionality other than to act as an entry point
# Scene Manager Controls the scenes

func _ready() -> void:
	#SceneManager.start_app()
	SceneManager.start_app_debug()
	queue_free()
