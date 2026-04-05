extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		SceneManager.current_scene.scene.report_player_finished()
		body.process_mode = Node.PROCESS_MODE_DISABLED
