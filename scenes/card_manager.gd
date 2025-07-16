extends Node2D

var cards: Array[Card] = []
var deck: Array[int] = []
var discard: Array[int] = []
var hand: Array[int] = []

@onready var hand_container: Container = %HandContainer
const CARD = preload("res://scenes/card.tscn")
@onready var points_label: Label = %PointsLabel
@onready var discard_label: Label = %DiscardLabel
@onready var deck_label: Label = %DeckLabel

func _ready() -> void:
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
	
	refresh_hand()

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
		hand.append(card_id)
	
	for child in hand_container.get_children():
		hand_container.remove_child(child)
	for card_id in hand:
		var card = cards[card_id]
		var card_scene = Card.create_card(card.type, card.level, card.card_id)
		hand_container.add_child(card_scene)
		
	deck_label.text = "Deck: " + str(len(deck))
	discard_label.text = "Discard: " + str(len(discard))
	
	print(
		"Deck: ",deck, "\n",
		"Discard: ", discard, "\n",
		"Hand: ", hand, "\n",
	)

func upgrade_card(id: int) -> void:
	print("UPGRADE")
	cards[id].level += 1

# ROUND MANAGEMENT

var round := 1
var num_hands := 5
var points := 0.0
var round_goal := 100

func _on_play_button_pressed() -> void:
	var score = hand_container.calculate_hand()
	round += 1
	points += score
	points_label.text = str(points)
	refresh_hand()
