extends Control
class_name Card

enum CardType {
	Add,
	Multiply,
	Upgrade
}

@export var type: CardType
@export var level: int
var card_id: int

@onready var value_label: Label = $Panel/VBoxContainer/ValueLabel
@onready var level_label: Label = $Panel/VBoxContainer/LevelLabel
var card_manager: Node2D

const CARD = preload("res://scenes/card.tscn")

var is_dragging := false
var is_over := false
var hand_container: HandContainer
var at_rest: bool = false

func _init(_type: CardType = CardType.Add, _level: int = 1, _card_id: int = 0) -> void:
	type = _type
	level = _level
	card_id = _card_id

func _ready() -> void:
	value_label.text = label()
	level_label.text = "Level " + str(level)
	hand_container = get_parent()
	card_manager = get_tree().root.get_child(0).get_child(0)
	
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

func card_action(score: float) -> float:
	match type:
		CardType.Add:
			return score + get_value()
		CardType.Multiply:
			return score * get_value()
		CardType.Upgrade:
			var cards = hand_container.get_children() as Array[Card]
			var index = cards.find(self)
			var next_card = cards[index + 1]
			print(next_card.card_id)
			if next_card:
				card_manager.upgrade_card(next_card.card_id)
			return score
		_:
			return score

func _process(delta: float) -> void:
	handle_drag(delta)
	
func handle_drag(delta: float) -> void:
	if (is_over or is_dragging) and (hand_container.dragging_card == null or hand_container.dragging_card == self):
		if Input.is_action_pressed("click"):
			self.z_index = 1000
			
			# Reorder on hover
			var closest_index = hand_container.get_closest_position_to_cursor()
			hand_container.move_child(self, closest_index)
			
			# Follow cursor
			global_position = lerp(global_position, get_global_mouse_position() - size/2, 22 * delta)
			
			is_dragging = true
			at_rest = false
			hand_container.dragging_card = self
		else:
			move_to_rest(delta)
			hand_container.dragging_card = null
			is_dragging = false
	else:
		move_to_rest(delta)

func move_to_rest(delta: float) -> void:
	if at_rest == true:
		return
	var resting_position = hand_container.get_resting_position(self)
	global_position = lerp(global_position, resting_position, 22 * delta)
	if resting_position == global_position:
		at_rest = true
		
	
		

func _on_mouse_entered() -> void:
	is_over = true

func _on_mouse_exited() -> void:
	is_over = false
