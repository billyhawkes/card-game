extends Node2D

# Game
signal stage_lost
signal stage_complete(rounds: int)

# HUD
signal play_hand

# Cards
signal upgrade_card(card_id: int, cost: int)
signal card_updated(card_id: int)
signal buy_card(type: int, level: int, cost: int)

# Menus
signal open_deck_menu

signal stage_updated(new: int)
signal round_updated(new: int)
signal goal_updated(new: int)
signal discard_updated(new: int)
signal deck_updated(new: int)
signal score_updated(new: int)
signal points_updated(new: int)
signal coins_updated(new: int)
