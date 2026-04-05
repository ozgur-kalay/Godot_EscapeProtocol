extends Control

func _on_restart_button_scene_menu_button_pressed() -> void:
	SceneManager.reload_current_scene()

func _on_exit_button_scene_menu_button_pressed() -> void:
	SceneManager.exit_game(name)
