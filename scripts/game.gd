extends Node2D

const GAME = preload("res://scenes/game/game.tscn")
const SHOP = preload("res://scenes/shop/shop.tscn")

var cards: Array[Card] = []
var stage := 0
var max_rounds := 5
var coins := 0

func _ready() -> void:
	EventBus.stage_complete.connect(_on_stage_complete)
	EventBus.upgrade_card.connect(_on_upgrade_card)
	
	load_cards()
	
func get_points_goal() -> float:
	var goal = 10.0
	for x in stage:
		goal *= 1.5
	return goal

func _on_upgrade_card(card_id: int) -> void:
	cards[card_id].level += 1

func _on_stage_complete() -> void:
	stage += 1
	get_tree().change_scene_to_packed(SHOP)
	
func start_game() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(GAME)

func load_cards() -> void:
	# TODO: Load cards from storage
	for x in 10:
		var card: Card
		if x < 7:
			card = Card.new(Card.CardType.Add, 1, x)
		elif x < 9:
			card = Card.new(Card.CardType.Multiply, 1, x)
		else:
			card = Card.new(Card.CardType.Upgrade, 1, x)
		cards.append(card)
