extends Node
class_name FadeModulator

signal fade_in_finished
signal fade_out_finished

enum ModulateTypes{MODULATE, SELF_MODULATE}
enum ProcessTypes{PHYSICS_PROCESS, PROCESS}
@export var print_signal_recieved: bool
## If not set, the parent will automatically be assigned as the client.
@export var client: CanvasItem
@export var modulate_type: ModulateTypes = ModulateTypes.MODULATE
@export var process_type: ProcessTypes = ProcessTypes.PHYSICS_PROCESS
@export var use_delta: bool = true

@export_category("Fade in Setup")
@export var fade_in_color: Color = Color.WHITE
@export var fade_in_time: float = 1.0
@export_group("Signal Enabling")
## The signal from which to enable from
@export var fade_in_client: Node
## Accepts up to 4 args.
@export var fade_in_signal: StringName

@export_category("Fade Out Setup")
## If set fade_out_color will have no effect.
@export var fade_back_to_default: bool = true
@export var fade_out_color: Color = Color.WHITE
@export var fade_out_time: float = 1.0
@export_group("Signal Enabling")
@export var fade_out_client: Node
## Accepts up to 4 args.
@export var fade_out_signal : StringName

enum FadeStates{IDLE, IN, OUT}
var current_fade_state: FadeStates

var dt: float = 1.0

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	if !client:
		client = get_parent()
	
	if fade_in_client:
		var _fade_in_signal: Signal = fade_in_client.get(fade_in_signal)
		_fade_in_signal.connect(_on_fade_in_signal_recieved)
	
	if fade_out_client:
		var _fade_out_signal: Signal = fade_out_client.get(fade_out_signal)
		_fade_out_signal.connect(_on_fade_out_signal_recieved)
	
	if fade_back_to_default:
		match modulate_type:
			ModulateTypes.MODULATE:
				fade_out_color = client.modulate
			ModulateTypes.SELF_MODULATE:
				fade_out_color = client.self_modulate
	
func _on_fade_in_signal_recieved(_args1 = null, _args2 = null, _args3 = null, _args4 = null) -> void:
	if print_signal_recieved:
		print(owner.name, "::", name, "::Fade In signal recieved")
	current_fade_state = FadeStates.IN

func _on_fade_out_signal_recieved(_args1 = null, _args2 = null, _args3 = null, _args4 = null) -> void:
	if print_signal_recieved:
		print(owner.name, "::", name, "::Fade Out signal recieved")
	current_fade_state = FadeStates.OUT

func _physics_process(delta: float) -> void:
	if process_type != ProcessTypes.PHYSICS_PROCESS:
		return
	
	if use_delta:
		dt = delta
	
	match current_fade_state:
		FadeStates.IN:
			_fade_in()
		FadeStates.OUT:
			_fade_out()
	

func _process(delta: float) -> void:
	if process_type != ProcessTypes.PROCESS:
		return
	
	if use_delta:
		dt = delta
	
	match current_fade_state:
		FadeStates.IN:
			_fade_in()
		FadeStates.OUT:
			_fade_out()
	
func _fade_in() -> void:
	var _time = .1 / fade_in_time
	client.modulate.r = move_toward(client.modulate.r, fade_in_color.r, _time)
	client.modulate.g = move_toward(client.modulate.g, fade_in_color.g, _time)
	client.modulate.b = move_toward(client.modulate.b, fade_in_color.b, _time)
	client.modulate.v = move_toward(client.modulate.v, fade_in_color.v, _time)
	if client.modulate == fade_in_color:
		current_fade_state = FadeStates.IDLE
		fade_in_finished.emit()

func _fade_out() -> void:
	var _time = .1 / fade_out_time
	client.modulate.r = move_toward(client.modulate.r, fade_out_color.r, _time)
	client.modulate.g = move_toward(client.modulate.g, fade_out_color.g, _time)
	client.modulate.b = move_toward(client.modulate.b, fade_out_color.b, _time)
	client.modulate.v = move_toward(client.modulate.v, fade_out_color.v, _time)
	if client.modulate == fade_out_color:
		current_fade_state = FadeStates.IDLE
		fade_out_finished.emit()
	
