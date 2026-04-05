extends Control

func _on_play_button_scene_menu_button_pressed() -> void:
	SceneManager.play_game()

func _on_exit_button_scene_menu_button_pressed() -> void:
	SceneManager.exit_game(owner.name)
