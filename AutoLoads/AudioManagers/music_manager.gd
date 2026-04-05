extends Node

@onready var ogg_dystopian_by_tim_beek: Node = $"OGG Dystopian by Tim Beek"


enum Songs{
	DarkAtmosphereToSynth,
	Dystopian,
	EmptyStreets,
	MysteryUnsolved,
	Surveillance,
	TheNightclub,
	TheProtagonist,
	TheStoryContinues
}

var current_song: AudioStreamPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func play(song_name: StringName) -> void:
	if current_song:
		current_song.stop()
	current_song = find_child(song_name)
	current_song.play()
