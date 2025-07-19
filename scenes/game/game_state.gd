extends CanvasLayer

@onready var hand_container: Container = %HandContainer

var rounds: int
var points: float
var points_goal: float

var is_playing_hand = false
var deck: Array[int] = []
var discard: Array[int] = []
var hand: Array[int] = []

func _ready() -> void:
	EventBus.play_hand.connect(_on_play_hand)
	
	rounds = Game.max_rounds
	points = 0.0
	points_goal = Game.get_points_goal()
	print(rounds, points, points_goal)
	
	# Fill deck randomly (Should happen at start of round)
	for index in len(Game.cards):
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
		else:
			hand.append(card_id)
	
	for child in hand_container.get_children():
		hand_container.remove_child(child)
	for card_id in hand:
		var card = Game.cards[card_id]
		var card_scene = HandCard.create_card(card.card_id)
		hand_container.add_child(card_scene)
	
	EventBus.deck_updated.emit(len(deck))
	EventBus.discard_updated.emit(len(discard))

func _on_play_hand() -> void:
	if is_playing_hand == false:
		is_playing_hand = true
		var hand_cards = hand_container.get_children()
		for card in hand_cards:
			var new_points = await card.play_card(points)
			points = new_points
			EventBus.points_updated.emit(points)
		rounds -= 1
		await get_tree().create_timer(1.0).timeout
		EventBus.round_updated.emit(rounds)
		if points >= points_goal:
			EventBus.stage_complete.emit(rounds)
		elif rounds == 0:
			EventBus.stage_lost.emit()
		
		refresh_hand()
		is_playing_hand = false
