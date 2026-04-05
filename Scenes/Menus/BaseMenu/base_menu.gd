extends Control

@export var enabled_on_start: bool = false
@export var testing : bool = false
var enabled: bool = true

var default_process_mode: ProcessMode

func _ready() -> void:
	default_process_mode = process_mode
	if enabled_on_start:
		enable()
	else:
		disable()

func enable() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	show()
	enabled = true

func disable() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	hide()
	enabled = false

func is_enabled() -> bool:
	return enabled
