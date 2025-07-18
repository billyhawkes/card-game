extends Control

@export var game_state: GameState
@onready var grid_container: GridContainer = $Background/Panel/VBoxContainer/GridContainer
const CARD = preload("res://scenes/card.tscn")

func _ready() -> void:
	EventBus.open_deck_menu.connect(_open_deck_menu)
	
func _open_deck_menu() -> void:
	get_tree().paused = true
	for card in game_state.cards:
		var new_card = CARD.instantiate()
		new_card.create_card(card.type, card.level, card.card_id)
		grid_container.add_child(new_card)
	visible = true

func _on_close_button_pressed() -> void:
	get_tree().paused = false
	visible = false
