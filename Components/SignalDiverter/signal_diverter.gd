extends Node
class_name SignalDiverter

@export var enabled: bool = true
@export var from_client: Node
@export var from_signal: StringName
@export var to_clients: Dictionary[Node, StringName]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var _signal: Signal = from_client.get(from_signal)
	_signal.connect(_from_signal)
	
func _from_signal() -> void:
	if !enabled:
		return
	for node in to_clients:
		node.call_deferred(to_clients[node]) 
		
