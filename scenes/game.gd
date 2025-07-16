extends Node2D

var cards: Array[Card] = []

var deck: Array[int] = []
var discard: Array[int] = []
var hand: Array[int] = []

@onready var hand_container: Container = %HandContainer
const CARD = preload("res://scenes/card.tscn")

func _ready() -> void:
	# TODO: Load cards from storage
	for x in 5:
		cards.append(Card.new(Card.CardType.Add, randi() % 2 + 1))
	for x in 5:
		cards.append(Card.new(Card.CardType.Multiply, randi() % 3 +1))

	# Fill deck randomly (Should happen at start of round)
	for index in len(cards):
		deck.append(index)
	deck.shuffle()
	
	refresh_hand()

# Algorithm
# 1. hand to discard
# 2. grab from deck
# 3. if nothing left in deck reshuffle into deck
func refresh_hand():
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
		var card_scene = Card.create_card(card.type, card.level)
		hand_container.add_child(card_scene)
	
	print(
		"Deck: ",deck, "\n",
		"Discard: ", discard, "\n",
		"Hand: ", hand, "\n",
	)
	
	


func _on_refresh_button_pressed() -> void:
	refresh_hand()
