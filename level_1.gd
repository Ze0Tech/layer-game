class_name Level1Type

extends Node2D


@onready var LevelItems : Array = get_children()
var Items : Array

signal Action(item:Area2D,command:String)

func _ready() -> void:
	for i : Node2D in LevelItems:
		var NewItems : Array = i.get_children()
		for q in NewItems:
			q.add_to_group(i.name)
			print(q.get_groups())
			q.connect('input_event',ItemInput.bind(q))

func ItemInput(item) -> void:
	Action.emit(item,'yay')
