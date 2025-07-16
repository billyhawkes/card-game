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

var is_dragging := false
var is_over := false
var card_container: HandContainer
var at_rest: bool = false

func _init(_type: CardType = CardType.Add, _level: int = 1) -> void:
	type = _type
	level = _level

func _ready() -> void:
	value_label.text = label()
	level_label.text = "Level " + str(level)
	card_container = get_parent()
	
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

func _process(delta: float) -> void:
	handle_drag(delta)
	
func handle_drag(delta: float) -> void:
	if (is_over or is_dragging) and (card_container.dragging_card == null or card_container.dragging_card == self):
		if Input.is_action_pressed("click"):
			self.z_index = 1000
			
			# Reorder on hover
			var closest_index = card_container.get_closest_position_to_cursor()
			card_container.move_child(self, closest_index)
			
			# Follow cursor
			global_position = lerp(global_position, get_global_mouse_position() - size/2, 22 * delta)
			
			is_dragging = true
			at_rest = false
			card_container.dragging_card = self
		else:
			move_to_rest(delta)
			card_container.dragging_card = null
			is_dragging = false
	else:
		move_to_rest(delta)

func move_to_rest(delta: float) -> void:
	if at_rest == true:
		return
	var resting_position = card_container.get_resting_position(self)
	global_position = lerp(global_position, resting_position, 22 * delta)
	if resting_position == global_position:
		at_rest = true
		
	
		

func _on_mouse_entered() -> void:
	is_over = true

func _on_mouse_exited() -> void:
	is_over = false
