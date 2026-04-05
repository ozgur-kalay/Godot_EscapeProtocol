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
		

enum States{SLEEP,PATROL, CHASE, RETURN}
enum PatrolIdxState{UP, DOWN}

@export var start_state: States = States.PATROL

@onready var state_machine: Node2DStateMachine = $StateMachine


var current_patrol_idx_state: PatrolIdxState = PatrolIdxState.UP

var default_location: Vector2
var patrol_points: Array[Vector2]
var patrol_index: int = 0

var patrol_speed: float = 70.0
var current_destination: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	default_location = position
	
	var temp_line: Line2D
	for child in get_children():
		if child is Line2D:
			temp_line = child
			
	if not temp_line:
		printerr(name, ":: Has NO line 2d")
	else:
		for i in temp_line.get_point_count():
			patrol_points.append(global_position + temp_line.get_point_position(i))

	temp_line.queue_free()

func activate() -> void:
	state_machine.change_state("PatrolState")
	#print(name, "::activate")

func deactivate() -> void:
	state_machine.change_state("SleepState")
	#print(name, "::deactivate")
	
func _patrol(delta: float):
	return
	current_destination = patrol_points[patrol_index]
	position = position.move_toward(current_destination, patrol_speed * delta)
	
	if position == current_destination:
		_update_patrol_index()
		
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

func look_left() -> void:
	$Sprite2D.flip_h = true
	$Sprite2D.look_at(global_position + Vector2.RIGHT)
	
	$POVLight.look_left()
	$Heart.look_left()
	
	
func look_right() -> void:
	$Sprite2D.flip_h = false
	$Sprite2D.look_at(global_position + Vector2.RIGHT)
	
	$POVLight.look_right()
	$Heart.look_right()
	
	
func look_up() -> void:
	$Sprite2D.look_at(global_position + Vector2.UP)
	$Sprite2D.flip_h = false
	
	$POVLight.look_up()
	$Heart.look_up()
	
func look_down() -> void:
	$Sprite2D.look_at(global_position + Vector2.DOWN)
	$Sprite2D.flip_h = false
	
	$POVLight.look_down()
	$Heart.look_down()
	
func scene_reset() -> void:
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
	
