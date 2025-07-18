extends Node2D
class_name GameState

@onready var hand_container: Container = %HandContainer

var stage := 1
var max_rounds := 5
var rounds := max_rounds
var points := 0.0
var points_goal := 10.0

var cards: Array[Card] = []
var deck: Array[int] = []
var discard: Array[int] = []
var hand: Array[int] = []

func _ready() -> void:
	EventBus.play_hand.connect(_on_play_hand)
	EventBus.upgrade_card.connect(_on_upgrade_card)
	
	load_cards()
	refresh_hand()

func _on_upgrade_card(card_id: int) -> void:
	cards[card_id].level += 1

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

	# Fill deck randomly (Should happen at start of round)
	for index in len(cards):
		deck.append(index)
	deck.shuffle()

# Algorithm
# 1. hand to discard
# 2. grab from deck
# 3. if nothing left in deck reshuffle into deck
func refresh_hand() -> void:
	for index in len(hand):
		var id = hand.pop_front()
		discard.append(id)
	
	while len(hand) < 5:
		var card_id = deck.pop_front()
		if card_id == null:
			for index in len(discard):
				var id = discard.pop_front()
				deck.append(id)
				deck.shuffle()
		else:
			hand.append(card_id)
	
	for child in hand_container.get_children():
		hand_container.remove_child(child)
	for card_id in hand:
		var card = cards[card_id]
		var card_scene = Card.create_card(card.type, card.level, card.card_id)
		hand_container.add_child(card_scene)
	
	EventBus.deck_updated.emit(len(deck))
	EventBus.discard_updated.emit(len(discard))

func calculate_hand() -> float:
	var hand_cards = hand_container.get_children()
	var score: float = 0.0
	for card in hand_cards:
		score = card.card_action(score)
	return score

func _on_play_hand() -> void:
	var score = calculate_hand()
	rounds -= 1
	points += score
	if points >= points_goal:
		points = 0
		points_goal = points_goal * 1.5
		rounds = max_rounds
		stage += 1
	elif rounds == 0:
		EventBus.game_lost.emit()
	
	EventBus.points_updated.emit(points)
	EventBus.round_updated.emit(rounds)
	EventBus.stage_updated.emit(stage)
	EventBus.goal_updated.emit(points_goal)
	
	refresh_hand()
