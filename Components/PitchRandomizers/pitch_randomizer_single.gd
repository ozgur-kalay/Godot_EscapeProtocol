@tool
extends Node
class_name PitchRandomizer

func _get_configuration_warnings() -> PackedStringArray:
	var _warning: PackedStringArray = []
	if not get_parent() is AudioStreamPlayer:
		_warning = ["PitchRandomizerSingle can only be child of an AudioStreamPlayer."]
	return _warning

@export var enabled: bool = true
##Once::Will randomize only once.
##OnFinished::Will randomize once at start then will randomize after each play.
@export_enum("Once", "OnFinished") var mode: String = "Once"
@export_range(0.01, 4.0) var min_pitch: float = 1.0
@export_range(0.01, 4.0) var max_pitch: float = 1.0

@export_category("Testing")
@export_tool_button("Test")
var test: Callable = func():
	var _parent: AudioStreamPlayer = get_parent()
	
	if !_parent.playing:
		client_default_pitch = _parent.pitch_scale
		
	get_parent().pitch_scale = randf_range(min_pitch, max_pitch)
	_parent.play()
	if !_parent.finished.is_connected(_reset_test_changes):
		_parent.finished.connect(_reset_test_changes)
		
@export_tool_button("Stop Test")
var stop_test: Callable = func():
	var _parent: AudioStreamPlayer = get_parent()
	_parent.stop()
	_reset_test_changes()

func _reset_test_changes() -> void:
	var _parent: AudioStreamPlayer = get_parent()
	_parent.pitch_scale = client_default_pitch
	if _parent.finished.is_connected(_reset_test_changes):
		_parent.finished.disconnect(_reset_test_changes)

var client: AudioStreamPlayer
var client_default_pitch: float = 1.0

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	if !enabled:
		return
	
	client = get_parent()
	client_default_pitch = client.pitch_scale
	client.pitch_scale = randf_range(min_pitch, max_pitch)
	if mode == "OnFinished":
		client.finished.connect(_randomize_on_finished)
		
func _randomize_on_finished() -> void:
	client.pitch_scale = randf_range(min_pitch, max_pitch)

func _exit_tree() -> void:
	if client:
		if client.finished.is_connected(_randomize_on_finished):
			client.finished.disconnect(_randomize_on_finished)
