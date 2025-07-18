extends Container
class_name HandContainer

var dragging_card: Card = null
var card_size = 256
	
func get_resting_positions() -> Array[Vector2]:
	var num_cards = get_child_count()
	var positions: Array[Vector2] = []
	for pos in num_cards:
		positions.append(Vector2(((global_position.x - (pos * -(card_size + 20.0))) - card_size * num_cards / 2.0) - num_cards / 2.0 * 20.0, global_position.y))
	return positions

func get_resting_position(card: Card) -> Vector2:
	var pos = get_children().find(card)
	var num_cards = get_child_count()
	var parent_x = global_position.x
	return Vector2(((parent_x - (pos * -(card_size + 20.0))) - card_size * num_cards / 2.0) - num_cards / 2.0 * 20.0, global_position.y)

func get_closest_position_to_cursor() -> int:
	var closest_index = null
	var closest_distance = null
	var resting_positions = get_resting_positions()
	for index in len(resting_positions):
		var pos = resting_positions[index]
		var distance = get_global_mouse_position().distance_to(Vector2(pos.x + card_size / 2.0, pos.y + card_size / 2.0))
		if closest_index == null:
			closest_distance = distance
			closest_index = index
		else:
			if distance < closest_distance:
				closest_distance = distance
				closest_index = index
	return closest_index
