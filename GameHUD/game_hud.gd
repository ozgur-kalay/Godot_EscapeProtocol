extends CanvasLayer

@export var player: Player

@onready var stamina_progress_bar: TextureProgressBar = $Stamina_ProgressBar

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	stamina_progress_bar.value = player.stamina_current
