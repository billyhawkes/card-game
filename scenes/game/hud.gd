extends VBoxContainer

@onready var round_label: Label = %RoundLabel
@onready var goal_label: Label = %GoalLabel
@onready var discard_label: Label = %DiscardLabel
@onready var deck_label: Label = %DeckLabel
@onready var points_label: Label = %PointsLabel
@onready var score_label: Label = $ScoreLabel

func _ready() -> void:
	EventBus.deck_updated.connect(func(new): deck_label.text = "Deck: " + str(new))
	EventBus.round_updated.connect(func(new): round_label.text = "Rounds: " + str(new))
	EventBus.goal_updated.connect(func(new): goal_label.text = "Goal: " + str(new))
	EventBus.score_updated.connect(func(new): score_label.text = str(new))
	EventBus.discard_updated.connect(func(new): discard_label.text = "Discard: " + str(new))
	EventBus.points_updated.connect(_on_points_updated)

	round_label.text = "Rounds: " + str(Game.max_rounds)
	goal_label.text = "Goal: " + str(Game.get_points_goal())
	points_label.pivot_offset.x = points_label.size.x 
	points_label.pivot_offset.y = points_label.size.y 


func _on_points_updated(new: float):
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(points_label, "scale", Vector2(1.1, 1.1), 0.1)
	tween.tween_property(points_label, "scale", Vector2(1.0, 1.0), 0.1)
	points_label.text = str(new)

func _on_play_button_pressed() -> void:
	EventBus.play_hand.emit()

func _on_deck_button_pressed() -> void:
	EventBus.open_deck_menu.emit()
