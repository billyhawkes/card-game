extends Node2D

# ROUND MANAGEMENT
@onready var card_manager: Node2D = %CardManager

var stage := 1
var max_rounds := 5
var round := max_rounds
var points := 0.0
var points_goal := 10
