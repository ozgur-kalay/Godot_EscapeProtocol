extends CharacterBody2D
class_name Player

signal player_dead

@onready var main_animation_player: AnimationPlayer = $Controllers/AnimationPlayers/MainAnimationPlayer
@onready var invisibility_animation: AnimationPlayer = $Controllers/AnimationPlayers/InvisibilityAnimation
@onready var state_machine: Character2DStateMachine = $Controllers/StateMachine
@onready var player_sprite_2d: Sprite2D = $PlayerSprite2D
@onready var hurt_box: HurtBox = $HurtBox

@export var walk_speed: float = 40 # 35
@export var run_speed: float = 67#57
@export var drag_speed: float = 25

@export var stamina_activate_threshold: float = 20.0
@export var stamina_max: float = 100.0
@export var stamina_current: float
@export var stamina_drain_rate: float = 0.2
@export var stamina_recovery_walk: float = 0.4
@export var stamina_recovery_idle: float = 0.8
@export var stamina_drag_drain_rate: float = 0.1

var previous_position: Vector2

var look_dir: Vector2 = Vector2.ZERO

var idle_modulation: Color = Color(0.6, 0.6, 0.6)
var walk_modulation: Color = Color(1.3, 1.3, 1.3)
var run_modulation: Color = Color(2.2, 2.2, 2.2)
var drag_modulation: Color = Color(1.5, 1.5, 1.5)
var dead_modulation: Color = Color(3.689, 0.0, 0.0, 1.0)
var invisibility_modulation: Color = Color(1.0, 1.0, 1.0, 0.3)
var modulation_change_speed: float = 10.0

var dragable: Dragable = null

var input_vect: Vector2

var spawn_position: Vector2
var spawn_rotation: float

var modulation_override: bool = false

var movement: Vector2

func _ready() -> void:
	modulate = idle_modulation
	spawn_position = global_position
	spawn_rotation = rotation
	stamina_current = stamina_max

func _physics_process(_delta: float) -> void:
	input_vect = Input.get_vector("left", "right", "up", "down")

func move(speed: float, _direction: Vector2, look: bool) -> void:
	previous_position = global_position
	
	var start: Vector2 = global_position
	velocity = _direction * speed
	move_and_slide()
	if look:
		_look()
	var end: Vector2 = global_position
	movement = start - end
	

func check_dragable() -> void:
	if dragable and Input.is_action_pressed("drag"):
		var delta: Vector2 = dragable.global_position - global_position
		var normal: Vector2

		if abs(delta.x) > abs(delta.y):
			# Horizontal direction
			normal = -Vector2(sign(delta.x), 0)
		else:
			# Vertical direction
			normal = -Vector2(0, sign(delta.y))
			
		if (abs(input_vect.x) + abs(input_vect.y)) <= 1:
			state_machine.change_state("GrabState", normal)

func drag(_direction: Vector2) -> void:
	dragable.velocity = velocity
	var dragable_colliding = dragable.move_and_slide()

	if dragable_colliding:
		for i in dragable.get_slide_collision_count():
			var collision: KinematicCollision2D = dragable.get_slide_collision(i)
			var _normal: Vector2 = collision.get_normal()
			if _normal.x != 0:
				_direction.x = _normal.x + sign(input_vect.x)
			elif _normal.y != 0:
				_direction.y = _normal.y + sign(input_vect.y)
	
	move(drag_speed, _direction , false)

func _look() -> void:
	var input_axis: Vector2 = Input.get_vector("left","right","up", "down")
	look_at(global_position + input_axis)

# Removing this function
func _depricated_lerp_sprite_modulation(to: Color, _delta: float = 1.0) -> void:
	if modulation_override:
		return
	if player_sprite_2d.modulate != to:
		player_sprite_2d.modulate = player_sprite_2d.modulate.lerp(to, modulation_change_speed * _delta)

func _on_hurt_box_health_finished(_hurt_box: HurtBox, _hit_box: HitBox) -> void:
	publish_player_dead()
	state_machine.change_state("DeadState")
	
func _on_drag_interactor_interaction_started(interactable: Interactable) -> void:
	if interactable.owner is Dragable:
		dragable = interactable.owner
	#print(name, "::drag interaction started, dragable = ", dragable)

func _on_drag_interactor_interaction_finished(interactable: Interactable) -> void:
	if interactable.owner is Dragable:
		dragable = null
	#print(name, "::drag interaction finished, dragable = ", dragable)

func _on_check_point_interactor_interaction_started(interactable: Interactable) -> void:
	spawn_position = interactable.owner.global_position

func _on_invisibility_field_interactor_interaction_started(interactable: Interactable) -> void:
	if interactable.owner is InvisibilityField:
		_make_invisible()
		
func publish_player_dead() -> void:
	player_dead.emit()

func play_main_animation(anim_name: String) -> void:
	main_animation_player.play(anim_name)

func stop_main_animation() -> void:
	main_animation_player.stop()
	
func _make_invisible() -> void:
	modulation_override = true
	hurt_box.disable()
	if invisibility_animation.is_playing():
		invisibility_animation.play("RESET")
	invisibility_animation.play("invisibility")
	await invisibility_animation.animation_finished
	modulation_override = false
	hurt_box.enable()
	
