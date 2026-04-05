extends Control

@onready var color_rect: ColorRect = $CenterContainer/ColorRect

func _ready() -> void:
	var adjustment = 200
	color_rect.custom_minimum_size = Vector2(get_viewport_rect().size.x - adjustment, get_viewport_rect().size.y - adjustment)
	de_activate()

func _process(delta: float) -> void:
	pass

func activate() -> void:
	show()
	set_process(true)
	
func de_activate() -> void:
	hide()
	set_process(false)

func _on_restart_button_scene_menu_button_pressed() -> void:
	SceneManager.reload_current_scene()

func _on_exit_button_scene_menu_button_pressed() -> void:
	get_tree().quit()
