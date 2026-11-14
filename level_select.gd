extends Node2D

@onready var Markers : Array = $Background/Markers.get_children()
@onready var GameScene : PackedScene = preload('res://Game.tscn')
@onready var LevelAreas : Array = $LevelAreas.get_children()

var Game : Node2D
var Levels : Array = []
var Level : int = 1

func _ready() -> void:
	for i : Node2D in LevelAreas:
		i.connect('input_event',LevelInput.bind(i))
		
	Setup()

func _process(_delta: float) -> void:

	InputCheck()

func InputCheck() -> void:
	if Input.is_action_just_pressed('Esc'):
		MainMenu()

func MainMenu() -> void:
	get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")
	queue_free()
	Game.queue_free()

func LevelInput(_viewport : Variant, input : InputEvent , _shape_idx: Variant, area : Area2D) -> void:
	if input.is_action_pressed('LMB'):
		LevelLoad(area.get_index())
	
func Setup() -> void:
	Game = GameScene.instantiate()
	Game.visible = false
	add_sibling(Game)
	
	for Scene : String in DirAccess.open("res://LevelScenes/").get_files():
		Scene = Scene.trim_suffix(".remap")
		Levels.append(load("res://LevelScenes/" + Scene))
	print(Levels)

func LevelLoad(index : int) -> void:
	print(Game)
	var NewLevel : Node2D = Levels[index].instantiate()
	Game.add_child(NewLevel)
	Game.visible = true
	Game.init()
	queue_free()
