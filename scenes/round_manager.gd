extends Node2D

signal end_game

# ROUND MANAGEMENT
@onready var round_label: Label = %RoundLabel
@onready var points_label: Label = %PointsLabel
@onready var goal_label: Label = %GoalLabel
@onready var card_manager: Node2D = %CardManager
@onready var stage_label: Label = %StageLabel

var stage := 1
var max_rounds := 5
var round := max_rounds
var points := 0.0
var points_goal := 10

func render_labels():
	round_label.text = "Round: " + str(round)
	points_label.text = str(points)
	goal_label.text = "Goal: " + str(points_goal)
	stage_label.text = "Stage: " + str(stage)

func _on_play_button_pressed() -> void:
	var score = card_manager.calculate_hand()
	round -= 1
	points += score
	if points >= points_goal:
		points = 0
		points_goal = points_goal * 1.5
		round = max_rounds
		stage += 1
	elif round == 0:
		end_game.emit()
	
	card_manager.refresh_hand()
	render_labels()

func _ready() -> void:
	render_labels()
