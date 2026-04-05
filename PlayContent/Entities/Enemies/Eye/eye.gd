@tool
extends Node2D

func _enter_tree() -> void:
	if get_parent() is SubViewport:
		return
	var has_line2d: bool = false
	
	for child in get_children():
		if child is Line2D:
			has_line2d = true
	
	if !has_line2d:
		var line2d: Line2D = Line2D.new()
		line2d.name = "Patrol Path"
		line2d.default_color = Color.BLUE
		add_child(line2d)
		line2d.owner = get_tree().edited_scene_root

enum States{PATROL, SLEEP}
@export var start_state: States = States.PATROL

enum StartLooks{LEFT, RIGHT, UP, DOWN}
@export var start_look: StartLooks = StartLooks.RIGHT

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shooting_laser_beam: ShootingLaserBeam = $ShootingLaserBeam
@onready var state_machine: Node2DStateMachine = $StateMachine
#@onready var ray_cast_2d: RayCast2D = $RayCast2D
#@onready var ray_cast_2d_2: RayCast2D = $RayCast2D2

# Patrol properties
enum PatrolIdxState{UP, DOWN}
var current_patrol_idx_state: PatrolIdxState = PatrolIdxState.UP
var default_location: Vector2
var patrol_points: Array[Vector2]
var patrol_index: int = 0
var patrol_speed: float = 70.0
var current_destination: Vector2

# Ray Casts
var ray_casts: Array[RayCast2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	default_location = position
	
	var temp_line: Line2D
	for child in get_children():
		if child is Line2D:
			temp_line = child
		if child is RayCast2D and child.name != "ShootingLaserBeam":
			#print(name, "::RayCast2D child = ", child.name)
			ray_casts.append(child)
			
	if not temp_line:
		printerr(name, ":: Has NO line 2d")
	else:
		for i in temp_line.get_point_count():
			patrol_points.append(global_position + temp_line.get_point_position(i))

	temp_line.queue_free()
	
	await get_tree().process_frame
	_update_direction()
	#match start_look:
		#StartLooks.RIGHT:
			#look_right()
		#StartLooks.LEFT:
			#look_left()
		#StartLooks.UP:
			#look_up()
		#StartLooks.DOWN:
			#look_down()
			
	if patrol_points.is_empty():
		push_error(name, "::No patrol points defined.")
	
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return

func search_target() -> void:
	for ray_cast in ray_casts:
		if ray_cast.is_colliding():
			_ray_cast_search(ray_cast)
	
	#else:
		#if !animation_player.is_playing():
			#animation_player.play("ray_cast_movement")

func is_target_hit() -> bool:
	return shooting_laser_beam.is_target_hit()

func _ray_cast_search(ray_cast: RayCast2D) -> void:
	var collider: Object = ray_cast.get_collider()
	if collider.name == "Detectable":
		#print(name, ":: ray detected detectable")
		var collision_point: Vector2 = ray_cast.get_collision_point()
		var _direction = ray_cast.position.direction_to(to_local(collision_point)).normalized() * 2
		var _extended_target: Vector2 = _direction * collision_point
		shooting_laser_beam.extend_to(name, collision_point)

func _patrol(delta: float):
	if patrol_points.is_empty():
		return
	
	current_destination = patrol_points[patrol_index]
	position = position.move_toward(current_destination, patrol_speed * delta)
	
	if position == current_destination:
		_update_patrol_index()
	
	_update_direction()
		
func _update_patrol_index():
	match current_patrol_idx_state:
		PatrolIdxState.UP:
			if patrol_index == patrol_points.size() - 1:
				#Change
				current_patrol_idx_state = PatrolIdxState.DOWN
			else:
				# Update
				patrol_index += 1
		PatrolIdxState.DOWN:
			if patrol_index == 0:
				current_patrol_idx_state = PatrolIdxState.UP
			else:
				patrol_index -= 1

func _update_direction() -> void:
	var direction = current_destination - global_position
	if direction.x > 0:
		look_right()
	elif direction.x < 0:
		look_left()
	elif direction.y < 0:
		look_up()
	elif direction.y > 0:
		look_down()

func look_left() -> void:
	rotation_degrees = -180
	
func look_right() -> void:
	rotation_degrees = 0
	
func look_up() -> void:
	rotation_degrees = -90
	
func look_down() -> void:
	rotation_degrees = 90

func scene_reset() -> void:
	animation_player.play("ray_cast_movement")
	match start_state:
		States.PATROL:
			state_machine.change_state("PatrolState")
		States.SLEEP:
			state_machine.change_state("SleepState")
	
	patrol_index = 0
	if !patrol_points.is_empty():
		current_destination = patrol_points[patrol_index]
		position = patrol_points[0]
	else:
		current_destination = Vector2.ZERO
		position = default_location
	current_patrol_idx_state = PatrolIdxState.UP

func activate() -> void:
	state_machine.change_state("PatrolState")

func deactivate() -> void:
	state_machine.change_state("SleepState")
