extends Control

class_name Card

enum CardType {
	Add,
	Multiply
}

@export var type: CardType
@export var level: int

@onready var value_label: Label = $Panel/VBoxContainer/ValueLabel
@onready var level_label: Label = $Panel/VBoxContainer/LevelLabel

const CARD = preload("res://scenes/card.tscn")

func _init(_type: CardType = CardType.Add, _level: int = 1) -> void:
	type = _type
	level = _level

func _ready() -> void:
	value_label.text = label()
	level_label.text = "Level " + str(level)
	
static func create_card(type: CardType, level: int) -> Card:
	var new_card: Card = CARD.instantiate()
	new_card.type = type
	new_card.level = level
	return new_card

func label() -> String:
	match type:
		CardType.Add:
			return "+" + str(level)
		CardType.Multiply:
			return "x" + str(level)
		_:
			return ""
