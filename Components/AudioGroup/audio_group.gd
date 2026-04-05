extends Node
class_name AudioGroup

signal finished

@export var auto_play: bool = false

var audio_players: Array[AudioStreamPlayer]

var finished_count: int = 0

func _ready() -> void:
	for child in get_children():
		if child is AudioStreamPlayer:
			audio_players.append(child)
			child.finished.connect(_audio_player_finished)
	if auto_play:
		play()

func play() -> void:
	if !_has_audio_players():
		return
	for audio in audio_players:
		audio.play()

func _audio_player_finished() -> void:
	finished_count += 1
	if finished_count == audio_players.size():
		finished_count = 0
		finished.emit()
		#print(name, "::emitting finished")

func _has_audio_players() -> bool:
	if audio_players.is_empty():
		printerr(owner.name ,"::", name, "::No audio players. Play aborted.")
		return false
	return true
