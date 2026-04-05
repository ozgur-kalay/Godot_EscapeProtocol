extends Sprite2D

@onready var point_light_2d: PointLight2D = $PointLight2D

func _ready() -> void:
	point_light_2d.color = Color.WEB_GREEN

func unlocked_state() -> void:
	point_light_2d.color = Color.WEB_GREEN

func locked_state() -> void:
	point_light_2d.color = Color.RED
