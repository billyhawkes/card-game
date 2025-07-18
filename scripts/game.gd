extends Node2D

const GAME = preload("res://scenes/game.tscn")
	
func start_game() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(GAME)
