extends Control

func _ready() -> void:
	EventBus.stage_lost.connect(_open_end_menu)
	
func _open_end_menu() -> void:
	get_tree().paused = true
	visible = true

func _on_restart_button_pressed() -> void:
	Game.start_game()
