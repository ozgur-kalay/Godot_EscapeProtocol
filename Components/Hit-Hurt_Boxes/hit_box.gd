@tool
extends Area2D
class_name HitBox

func _enter_tree() -> void:
	collision_layer = 1 << 3
	collision_mask = 1 << 2
	if get_parent() is SubViewport:
		return
	var has_collision_shape: bool = false
	
	for child in get_children():
		if child is CollisionShape2D:
			has_collision_shape = true
	
	if !has_collision_shape:
		var _collision_shape: CollisionShape2D = CollisionShape2D.new()
		_collision_shape.debug_color = Color(0, 0.4, 0, 0.4)
		add_child(_collision_shape, true)
		_collision_shape.owner = get_tree().edited_scene_root

signal contact_entered(hurt_box: HurtBox)
signal contact_exited(hurt_box: HurtBox)

@export var disable_on_start: bool = true
@export var disable_on_contact: bool = true
@export var damage: int = 1

var default_process_mode: ProcessMode
var enabled: bool = true
var collision_shape: CollisionShape2D

func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	default_process_mode = process_mode
	
	for child in get_children():
		if child is CollisionShape2D:
			collision_shape = child
			break
	
	if !collision_shape:
		printerr(owner.name,"::", name, "::Has no collision shape!")
		
	if disable_on_start:
		disable()
	
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _on_area_entered(area: Area2D) -> void:
	if not area is HurtBox:
		return
	var _hurtbox: HurtBox = area
	_hurtbox.take_damage(self, damage)
	contact_entered.emit(_hurtbox)
	print(name, "::hurt box detected")
	if disable_on_contact:
		print(name, ": Disabling on contact")
		disable()
	else:
		print(name, ":: disable on contact turned off")

func _on_area_exited(area: Area2D) -> void:
	if not area is HurtBox:
		return
	contact_exited.emit(area)

func enable() -> void:
	enabled = true
	set_deferred("process_mode", default_process_mode)
	collision_shape.set_deferred("disabled", false)
	#print(owner.name, "::", name, ":: enabled")
	
func disable() -> void:
	enabled = false
	set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	collision_shape.set_deferred("disabled", true)
	#print(owner.name, "::", name, ":: disabled")

func is_enabled() -> bool:
	return enabled
