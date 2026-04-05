extends Camera2D

@export var use_limits: bool = true
@export var tilemap_layer: TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !tilemap_layer:
		printerr(owner.name, "::", name, "::No TileMapLayer given! Limits will not be set automatically.")
		return
	if use_limits:
		_set_limits()
	position_smoothing_enabled = true
	position_smoothing_speed = 7.0
	drag_horizontal_enabled = true
	drag_vertical_enabled = true
	var drag_margin: float = 0.03
	drag_left_margin = drag_margin
	drag_right_margin = drag_margin
	drag_top_margin = drag_margin
	drag_bottom_margin = drag_margin

func _set_limits():
	var map_rect: Rect2i = tilemap_layer.get_used_rect()
	var tile_size: Vector2i = tilemap_layer.tile_set.tile_size
	
	limit_top = map_rect.position.y * tile_size.y
	limit_bottom = (map_rect.position.y + map_rect.size.y) * tile_size.y
	
	limit_left = map_rect.position.x * tile_size.x
	limit_right = (map_rect.position.x + map_rect.size.x) * tile_size.x
