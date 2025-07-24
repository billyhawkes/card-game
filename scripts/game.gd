extends Node2D

const GAME = preload("res://scenes/game/game.tscn")
const SHOP = preload("res://scenes/shop/shop.tscn")
const MUSIC = preload("res://assets/audio/music.wav")

var cards: Array[Card] = []
var stage := 0
var max_rounds := 5
var coins := 0

func _ready() -> void:
	EventBus.stage_complete.connect(_on_stage_complete)
	EventBus.upgrade_card.connect(_on_upgrade_card)
	EventBus.buy_card.connect(_on_buy_card)
	
	load_cards()
	
func get_points_goal() -> float:
	var initial_goal = 12.0
	for x in stage:
		initial_goal *= 1.5
	return snapped(initial_goal, 0.1)

func get_base_rounds() -> int:
	# Find extra round cards
	var extra_rounds = 0
	for card in cards:
		if card.type == Card.CardType.ExtraRound:
			extra_rounds += 1
	return max_rounds + extra_rounds

func _on_upgrade_card(card_id: int, cost: int) -> void:
	var card = cards[card_id]
	if coins >= cost:
		cards[card_id].level += 1
		coins -= cost
		EventBus.coins_updated.emit(coins)
		EventBus.card_updated.emit(card_id)

func _on_buy_card(type: Card.CardType, level:int, cost: int) -> void:
	if coins >= cost:
		coins -= cost
		cards.append(Card.new(type, level, len(cards)))
		EventBus.coins_updated.emit(coins)

func _on_stage_complete(rounds: int) -> void:
	coins += 5 + rounds
	stage += 1
	get_tree().change_scene_to_packed(SHOP)
	
func start_game() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(GAME)

func restart_game() -> void:
	cards = []
	load_cards()
	stage = 0
	coins = 0
	start_game()
	

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
