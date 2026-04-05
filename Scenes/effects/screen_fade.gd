extends Control

signal finished

@export_enum("FadeIn", "FadeOut") var mode: String = "FadeIn"
@export var fade_duration : float
@export_color_no_alpha var color
@export var auto_start: bool
@export var auto_start_delay: float

@onready var color_rect: ColorRect = $ColorRect

@export_category("Activate On Signal")
@export var signal_client: Node
@export var signal_name: StringName
@export var on_signal_delay: float

func _ready() -> void:
	_set_color()
	if signal_client:
		_connect_on_signal()
		return
	if auto_start:
		await get_tree().create_timer(auto_start_delay).timeout
		activate()

func _set_color() -> void:
	color_rect.color.r = color.r
	color_rect.color.g = color.g
	color_rect.color.b = color.b
	match mode:
		"FadeIn":
			color_rect.color.a = 1.0
		"FadeOut":
			color_rect.color.a = 0.0

func _connect_on_signal() -> void:
	if (!signal_client.has_signal(signal_name)):
		printerr(owner.name, ":", name, ": Activate On Signal: invalid signal from client!")
		return
	
	var _signal: Signal = signal_client.get(signal_name)
	_signal.connect(_on_client_signal)

func _on_client_signal() -> void:
	await get_tree().create_timer(on_signal_delay).timeout
	activate()

func activate() -> void:
	match mode:
		"FadeIn":
			color_rect.color.a = 1.0
			_fade_in()
		"FadeOut":
			color_rect.color.a = 0.0
			_fade_out()

func _fade_in() -> void:
	var tween: Tween = create_tween()
	var target_color: Color = Color(color_rect.color.r, color_rect.color.g, color_rect.color.b, 0.0)
	tween.tween_property(color_rect, "color", target_color, fade_duration)
	await tween.finished
	finished.emit()
	
func _fade_out() -> void:
	var tween: Tween = create_tween()
	var target_color: Color = Color(color_rect.color.r, color_rect.color.g, color_rect.color.b, 1.0)
	tween.tween_property(color_rect, "color", target_color, fade_duration)
	await tween.finished
	finished.emit()
