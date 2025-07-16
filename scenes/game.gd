extends Node2D

const GAME = preload("res://scenes/game.tscn")
const END_MENU = preload("res://scenes/menus/end_menu.tscn")

func game_lost() -> void:
	var end_menu: Control = END_MENU.instantiate()
	var canvas_layer = get_tree().current_scene.find_child("CanvasLayer", true)
	get_tree().paused = true
	canvas_layer.add_child(end_menu)
	
func start_game() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(GAME)
