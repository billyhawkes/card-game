extends CanvasLayer

@onready var upgrade_container: HBoxContainer = %UpgradeContainer
@onready var buy_container: HBoxContainer = %BuyContainer

func _ready() -> void:
	var card_copy = Game.cards.duplicate()
	card_copy.shuffle()
	for card in card_copy.slice(0,5):
		var new_card = ShopCard.create_card(card.type, card.level, card.card_id, ShopCard.ShopType.Upgrade)
		upgrade_container.add_child(new_card)
	for x in 5:
		var type = randi() % len(Card.CardType.keys())
		var new_card = ShopCard.create_card(type, (randi() % (Game.stage + 1) + 1), -1, ShopCard.ShopType.Buy)
		buy_container.add_child(new_card)


func _on_start_stage_button_pressed() -> void:
	GlobalAudio.play_click()
	Game.start_game()
