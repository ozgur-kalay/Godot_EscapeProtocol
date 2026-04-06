extends Area2D
class_name DragableComponent

var print_header: String

## If not set, then the direct parent is set as the client automatically.
@export var client: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print_header = owner.name + ":" + name + ":"
	area_entered.connect(_on_area_entered)
	
	if !client:
		client = get_parent()
	
func _on_area_entered(area: Area2D) -> void:
	pass
	#print(print_header, "area = ", area.name)
