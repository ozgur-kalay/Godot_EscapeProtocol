extends Node2D

# By default the button entity is always ON at start

signal button_on
signal button_off

var on_state_sprite_region: Rect2 = Rect2(0, 0, 32, 32)
var off_state_sprite_region: Rect2 = Rect2(32, 0, 32, 32)

var on_state_sprite_v: float = 5.0
var off_state_sprite_v: float = 1.0

func publish_on() -> void:
	button_on.emit()
	
func publish_off() -> void:
	button_off.emit()
