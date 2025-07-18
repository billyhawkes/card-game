extends Control

@onready var stage_label: Label = $StageLabel
@onready var coins_label: Label = $CoinsLabel

func _ready() -> void:
	stage_label.text = str("Stage: ", Game.stage)
	coins_label.text = str("Coins: ", Game.coins)
	EventBus.stage_updated.connect(func(new): stage_label.text = "Stage: " + str(new))
	EventBus.coins_updated.connect(func(new): coins_label.text = "Coins: " + str(new))
