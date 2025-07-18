extends Control

func _ready() -> void:
	EventBus.open_deck_menu.connect(_open_deck_menu)
	
func _open_deck_menu() -> void:
	get_tree().paused = true
	visible = true

func _on_close_button_pressed() -> void:
	get_tree().paused = false
	visible = false
