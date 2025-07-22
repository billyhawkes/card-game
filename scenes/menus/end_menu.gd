extends Control
@onready var stage_label: Label = %StageLabel

func _ready() -> void:
	EventBus.stage_lost.connect(_open_end_menu)
	
func _open_end_menu() -> void:
	get_tree().paused = true
	stage_label.text = str("You made it to stage: ", Game.stage)
	visible = true

func _on_restart_button_pressed() -> void:
	Game.cards = []
	Game.load_cards()
	Game.start_game()
