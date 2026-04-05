extends Node
class_name GameScene

signal scene_finished
@export_category("Music")
@export var song_name: StringName
@export_category("Finish On Signal")
@export var signal_client: Node
@export var signal_name: StringName
@export var on_signal_delay: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (signal_client):
		_connect_on_signal()
	if !song_name.is_empty():
		MusicManager.play(song_name)

func _process(_delta: float) -> void:
	if !find_child("InGameMenu"):
		return
	if Input.is_action_just_pressed("ui_cancel"):
		var menu = find_child("InGameMenu")
		if menu.enabled:
			menu.disable()
			
		else:
			menu.enable()
	

func _connect_on_signal() -> void:
	if (!signal_client.has_signal(signal_name)):
		printerr(owner.name, ":", name, ": Activate On Signal: invalid signal from client!")
		return
	
	var _signal: Signal = signal_client.get(signal_name)
	_signal.connect(_on_client_signal)

func _on_client_signal() -> void:
	await get_tree().create_timer(on_signal_delay).timeout
	finish()

func report_player_dead() -> void:
	get_tree().call_group("scene_reset", "scene_reset")
	
	#for _node in get_tree().get_nodes_in_group("scene_reset"):
		#_node.call("scene_reset")

func report_player_finished() -> void:
	SceneManager._load_next_scene()
	#if SceneManager.is_last_level():
		#find_child("GameCompletedMenu").enable()
	#else:
		#find_child("LevelFinishedMenu").enable()

func finish() -> void:
	scene_finished.emit()
