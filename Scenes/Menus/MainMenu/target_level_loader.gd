extends Control

func _on_level_1_button_pressed() -> void:
	#SceneManager._load_target_scene("Level1")
	SceneManager._load_target_scene(SceneManager.SCENES.LEVEL1)
	


func _on_level_2_button_pressed() -> void:
	#SceneManager._load_target_scene("Level2")
	SceneManager._load_target_scene(SceneManager.SCENES.LEVEL2)


func _on_level_3_button_pressed() -> void:
	SceneManager._load_target_scene(SceneManager.SCENES.LEVEL3)
