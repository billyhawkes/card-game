extends Node2D

signal game_lost

# HUD
signal play_hand

# Cards
signal upgrade_card(card_id: int)

# Menus
signal open_deck_menu

signal stage_updated(new: int)
signal round_updated(new: int)
signal goal_updated(new: int)
signal discard_updated(new: int)
signal deck_updated(new: int)
signal points_updated(new: int)
