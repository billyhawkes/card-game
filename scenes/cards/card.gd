extends Control
class_name Card

enum CardType {
	Add,
	Multiply,
	Upgrade
}

var type: CardType
var level: int
var card_id: int

@onready var level_label: Label = %LevelLabel
@onready var value_label: Label = %ValueLabel

const CARD = preload("res://scenes/cards/card.tscn")

func _init(_type: CardType = CardType.Add, _level: int = 1, _card_id: int = 0) -> void:
	type = _type
	level = _level
	card_id = _card_id

func _ready() -> void:
	value_label.text = label()
	level_label.text = "Level " + str(level)
	
static func create_card(_type: CardType, _level: int, _card_id: int) -> Card:
	var new_card: Card = CARD.instantiate()
	new_card.type = _type
	new_card.level = _level
	new_card.card_id = _card_id
	return new_card
	
func get_value():
	match type:
		CardType.Add:
			return level
		CardType.Multiply:
			return 1 + (level * 0.1)
		_:
			return ""

func label() -> String:
	match type:
		CardType.Add:
			return "+" + str(get_value())
		CardType.Multiply:
			return "x" + str(get_value())
		CardType.Upgrade:
			value_label.add_theme_font_size_override("font_size", 56)
			return "Upgrade"
		_:
			return ""
