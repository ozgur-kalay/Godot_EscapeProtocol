extends Control


func _on_main_menu_button_scene_menu_button_pressed() -> void:
	SceneManager.load_main_menu()


func _on_exit_button_scene_menu_button_pressed() -> void:
	SceneManager.exit_game(owner.name)
