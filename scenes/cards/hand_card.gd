extends Control
class_name HandCard

var is_dragging := false
var is_over := false
var hand_container: HandContainer
var at_rest: bool = false
var card: Card
const HAND_CARD = preload("res://scenes/cards/hand_card.tscn")
var modify_resting_postion: Vector2

func _ready() -> void:
	hand_container = get_parent()

func _process(delta: float) -> void:
	handle_drag(delta)

static func create_card(card_id: int) -> HandCard:
	var new_card: HandCard = HAND_CARD.instantiate()
	var _card = Game.cards[card_id]
	new_card.card = new_card.get_child(0)
	new_card.card.level = _card.level
	new_card.card.type = _card.type
	new_card.card.card_id = _card.card_id
	return new_card
	
func handle_drag(delta: float) -> void:
	if (is_over or is_dragging) and (hand_container.dragging_card == null or hand_container.dragging_card == self):
		if Input.is_action_pressed("click"):
			GlobalAudio.play_click()
			self.z_index = 1000
			
			# Reorder on hover
			var closest_index = hand_container.get_closest_position_to_cursor()
			hand_container.move_child(self, closest_index)
			
			# Follow cursor
			global_position = lerp(global_position, get_global_mouse_position() - size/2, 22 * delta)
			
			is_dragging = true
			at_rest = false
			hand_container.dragging_card = self
		else:
			move_to_rest(delta)
			hand_container.dragging_card = null
			is_dragging = false
	else:
		move_to_rest(delta)

func move_to_rest(delta: float) -> void:
	if at_rest == true:
		return
	var resting_position = hand_container.get_resting_position(self) + modify_resting_postion
	global_position = lerp(global_position, resting_position, 22 * delta)
	if resting_position == global_position:
		at_rest = true
		
func play_card(score: float) -> float:
	modify_resting_postion.y -= 20
	await get_tree().create_timer(0.5).timeout
	modify_resting_postion.y += 20
	match card.type:
		Card.CardType.Add:
			return score + card.get_value()
		Card.CardType.Multiply:
			return score * card.get_value()
		Card.CardType.Upgrade:
			var hand_cards = hand_container.get_children() as Array[HandCard]
			var index = hand_cards.find(self)
			
			if len(hand_cards) > index + 1:
				var next_card = hand_cards[index + 1]
				# Prevent upgrading upgrade card
				if next_card.card.type != Card.CardType.Upgrade:
					for x in card.level:
						EventBus.upgrade_card.emit(next_card.card.card_id, 0)
			return score
		Card.CardType.Coin:
			Game.coins += card.level
			EventBus.coins_updated.emit(Game.coins)
			return score
		_:
			return score
		

func _on_mouse_entered() -> void:
	is_over = true

func _on_mouse_exited() -> void:
	is_over = false
