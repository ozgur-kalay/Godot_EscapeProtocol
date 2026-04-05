@tool
extends Node2D
class_name EntityDetectorArea2D

signal detectable_entity_entered(detectable_entity: DetectableEntity, arg)
signal detectable_entity_exited(detectable_entity: DetectableEntity)

func _enter_tree() -> void:
	var has_area2d: bool = false
	
	for child in get_children():
		if child is Area2D:
			has_area2d = true
			
	if !has_area2d:
		var _area2d: Area2D = Area2D.new()
		add_child(_area2d, true)
		_area2d.owner = get_tree().edited_scene_root
		
		var _collision_shape: CollisionShape2D = CollisionShape2D.new()
		var _shape: CircleShape2D = CircleShape2D.new()
		_shape.radius = 80
		_collision_shape.shape = _shape
		_area2d.add_child(_collision_shape, true)
		_collision_shape.owner = get_tree().edited_scene_root

var area2d: Area2D

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	var has_area2d: bool
	
	for child in get_children():
		if child is Area2D:
			area2d = child
			has_area2d = true
			
	if !has_area2d:
		printerr(owner.name, "::", name, "::Does not have an Area2D node. Please add one.")
		return
	
	area2d.area_entered.connect(_on_area_entered)
	area2d.area_exited.connect(_on_area_exited)
	
func _on_area_entered(_area: Area2D) -> void:
	if !_area is DetectableEntity:
		printerr(owner.name, "::", name, "::WARNING! EntiyDetectorArea2D has detected an area node that is not of type DetectableEntity. Check your collision layers and masks.")
	else:
		detectable_entity_entered.emit(_area, 1)
	
func _on_area_exited(_area: Area2D) -> void:
	if !_area is DetectableEntity:
		printerr(owner.name, "::", name, "::WARNING! EntiyDetectorArea2D has detected an area node that is not of type DetectableEntity. Check your collision layers and masks.")
	else:
		detectable_entity_exited.emit(_area)
