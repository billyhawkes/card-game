extends Control
class_name ShopCard

var card: Card
const SHOP_CARD = preload("res://scenes/cards/shop_card.tscn")

@onready var buy_button: Button = %BuyButton
@onready var upgrade_button: Button = %UpgradeButton


enum ShopType  {
	Upgrade,
	Buy
}
var shop_type: ShopType

func _ready() -> void:
	match shop_type:
		ShopType.Upgrade:
			buy_button.visible = false
			upgrade_button.text = str("$", card.get_upgrade_cost())
		ShopType.Buy:
			upgrade_button.visible = false
	

static func create_card(_type: Card.CardType, _level: int, _card_id: int) -> ShopCard:
	var new_card: ShopCard = SHOP_CARD.instantiate()
	new_card.card = new_card.get_child(0)
	new_card.card.level = _level
	new_card.card.type = _type
	new_card.card.card_id = _card_id
	if Game.cards.find(_card_id):
		new_card.shop_type = ShopType.Upgrade
	else:
		new_card.shop_type = ShopType.Buy
	return new_card


func _on_upgrade_button_pressed() -> void:
	EventBus.upgrade_card.emit(card.card_id, card.get_upgrade_cost())
	upgrade_button.text = str("$", card.get_upgrade_cost())
