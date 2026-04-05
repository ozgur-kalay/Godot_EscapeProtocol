extends Button
class_name SceneMenuButton

signal scene_menu_button_pressed

@onready var focused_sound: AudioStreamPlayer = $FocusedSound
@onready var pressed_sound: AudioStreamPlayer = $PressedSound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_on_pressed)
	focus_entered.connect(_on_focus_entered)
	mouse_entered.connect(_on_mouse_entered)

func _on_focus_entered() -> void:
	focused_sound.play()

func _on_mouse_entered() -> void:
	grab_focus()

func _on_pressed() -> void:
	pressed_sound.play()
	await pressed_sound.finished
	scene_menu_button_pressed.emit()
