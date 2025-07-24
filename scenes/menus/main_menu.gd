extends CanvasLayer


func _on_start_button_pressed() -> void:
	GlobalAudio.play_click()
	Game.start_game()


func _on_quit_button_pressed() -> void:
	GlobalAudio.play_click()
	get_tree().quit()
