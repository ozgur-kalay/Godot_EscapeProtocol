extends Node

class SceneRef:
	var scene: GameScene = null
	var scene_key: SceneManager.SCENES
	func _init() -> void:
		pass

enum SCENES{TEST, INTRO, MAINMENU, LEVEL1, LEVEL2, LEVEL3, GAMEFINISHEDSCENE}

var scenes: Dictionary = {
	SCENES.TEST 	:"res://Test/TestScene.tscn",
	SCENES.INTRO 	:"res://Scenes/intro_scene.tscn",
	SCENES.MAINMENU :"res://Scenes/MainMenuScene/main_menu_scene.tscn",
	SCENES.LEVEL1 	:"res://Scenes/PlayScenes/level_one_scene.tscn",
	SCENES.LEVEL2 	:"res://Scenes/PlayScenes/level_two_scene.tscn",
	SCENES.LEVEL3 	:"res://Scenes/PlayScenes/level_three_scene.tscn",
	SCENES.GAMEFINISHEDSCENE : 	"res://Scenes/GameFinishedScene/game_finished_scene.tscn"
}

var scene_index: int = 0
var debug: bool
var current_scene: SceneRef

func _ready() -> void:
	current_scene = SceneRef.new()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func start_app() -> void:
	_load_target_scene(SCENES.INTRO)
	#print(name, ": Start app")

func start_app_debug() -> void:
	#print(name, ": Start app debug")
	_load_target_scene(scenes.keys()[scene_index])
	debug = true

#called by main menu
func play_game() -> void:
	#_load_scene("LevelOne")
	_load_next_scene()

#called by Game over menu
func reload_current_scene() -> void:
	_delete_scene(current_scene)
	_load_target_scene(current_scene.scene_key)

func _delete_scene(_current_scene: SceneRef) -> void:
	_current_scene.scene.scene_finished.disconnect(_on_scene_finished)
	await get_tree().create_timer(0.1).timeout
	get_tree().root.remove_child(_current_scene.scene)
	_current_scene.scene.queue_free()
	_current_scene.scene = null

func _load_next_scene() -> void:
	scene_index += 1
	_load_target_scene(scenes.keys()[scene_index])

func _load_target_scene(_scene_key: SceneManager.SCENES) -> void:
	if (current_scene.scene):
		_delete_scene(current_scene)
		print(name, "::Current scene deleted")
	
	await get_tree().create_timer(.5).timeout
	scene_index = scenes.keys().find(_scene_key)
	current_scene.scene = load(scenes[_scene_key]).instantiate()
	current_scene.scene_key = _scene_key
	get_tree().root.call_deferred("add_child", current_scene.scene)
	current_scene.scene.scene_finished.connect(_on_scene_finished)

func _on_scene_finished() -> void:
	_load_next_scene()

func exit_game(_caller_name: String) -> void:
	get_tree().quit()

func is_last_level() -> bool:
	if scene_index == scenes.size():
		return true
	else:
		return false

func load_main_menu() -> void:
	scene_index = 1
	_load_target_scene(SCENES.MAINMENU)
