@tool
extends Area2D
class_name HurtBox

func _enter_tree() -> void:
	collision_layer = 1 << 2
	collision_mask = 1 << 3
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

signal health_finished(hurt_box: HurtBox, hit_box: HitBox)

@export var disable_on_start: bool = false
@export var disable_on_contact: bool = false
@export var disable_on_health_finished: bool = false

@export var health: int = 1

var enabled: bool = true
var collision_shape: CollisionShape2D

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
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

func enable() -> void:
	enabled = true
	process_mode = Node.PROCESS_MODE_INHERIT
	
func disable() -> void:
	enabled = false
	process_mode = Node.PROCESS_MODE_DISABLED

func is_enabled() -> bool:
	return enabled

# Detects Hit box
func _on_area_entered(area: Area2D) -> void:
	if not area is HurtBox:
		return
	contact_entered.emit(area)
	if disable_on_contact:
		disable()

func _on_area_exited(area: Area2D) -> void:
	if not area is HurtBox:
		return
	contact_exited.emit(area)
	
func take_damage(hitbox: HitBox, damage: int) -> void:
	health -= damage
	print(owner.name, "::", name, "::take_damage::health = ", health)
	if health <= 0:
		health_finished.emit(self, hitbox)
		if disable_on_health_finished:
			disable()
