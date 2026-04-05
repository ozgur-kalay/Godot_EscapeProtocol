@tool
extends Node2D

var default_light_offset_y: float = 10

@export var light_scale: Vector2 = Vector2.ONE :
	get: return light_scale
	set(value):
		light_scale = value
		for child in get_children():
			if child is PointLight2D:
				child.scale = value

@export var offset: Vector2 = Vector2.ZERO :
	get: return offset
	set(value):
		offset = value
		for child in get_children():
			if child is PointLight2D:
				child.offset.x = offset.x
				child.offset.y = offset.y + default_light_offset_y
