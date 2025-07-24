extends Control

@onready var card_container: FlowContainer = %CardContainer

func _ready() -> void:
	EventBus.open_deck_menu.connect(_open_deck_menu)
	
func _open_deck_menu() -> void:
	get_tree().paused = true
	for card in Game.cards:
		print(card.type, card.card_id)
		var new_card = Card.create_card(card.type, card.level, card.card_id)
		card_container.add_child(new_card)
	visible = true

func _on_close_button_pressed() -> void:
	GlobalAudio.play_click()
	for child in card_container.get_children():
		card_container.remove_child(child)
	get_tree().paused = false
	visible = false
