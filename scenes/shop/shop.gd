extends CanvasLayer

@onready var upgrade_container: HBoxContainer = %UpgradeContainer

func _ready() -> void:
	var card_copy = Game.cards.duplicate()
	card_copy.shuffle()
	for card in card_copy.slice(0,5):
		var new_card = Card.create_card(card.type, card.level, card.card_id)
		upgrade_container.add_child(new_card)


func _on_start_stage_button_pressed() -> void:
	Game.start_game()
