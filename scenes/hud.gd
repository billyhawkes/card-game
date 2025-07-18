extends VBoxContainer

@onready var stage_label: Label = %StageLabel
@onready var round_label: Label = %RoundLabel
@onready var goal_label: Label = %GoalLabel
@onready var discard_label: Label = %DiscardLabel
@onready var deck_label: Label = %DeckLabel
@onready var points_label: Label = %PointsLabel

func _ready() -> void:
	EventBus.deck_updated.connect(func(new): deck_label.text = "Deck: " + str(new))
	EventBus.round_updated.connect(func(new): round_label.text = "Round: " + str(new))
	EventBus.goal_updated.connect(func(new): goal_label.text = "Goal: " + str(new))
	EventBus.discard_updated.connect(func(new): discard_label.text = "Discard: " + str(new))
	EventBus.stage_updated.connect(func(new): stage_label.text = "Stage: " + str(new))
	EventBus.points_updated.connect(func(new): points_label.text = str(new))


func _on_play_button_pressed() -> void:
	EventBus.play_hand.emit()

func _on_deck_button_pressed() -> void:
	EventBus.open_deck_menu.emit()
