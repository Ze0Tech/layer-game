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
	pass
	#InputCheck()
	
#func InputCheck():
	#if Input.is_action_just_pressed('Q'):
		#NextLevel()

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
	#Level = index+1
#func NextLevel() -> void:
	#if Game.get_child(3) and Game.get_child(3).is_in_group('Levels'):
		#Game.get_child(3).queue_free()
	#if Levels.size() > 0:
		#LevelLoad()
#
#func LevelLoad() -> void:
	#var NewGame : Node = GameScene.instantiate()
	#var Level : Node2D = Levels.pop_front().instantiate()
	#Level.name = 'Level'
	#Game.add_child(Level)
	#add_sibling(Game)
	#
	
	#add_child(Level)
	#Level.name = 'Level'
	#Level.add_to_group('Levels')
	#Level.connect('Action',LevelAction)
	##
