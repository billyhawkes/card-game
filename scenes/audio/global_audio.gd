extends Node

@onready var click_sound: AudioStreamPlayer = $ClickSound

func play_click() -> void:
	click_sound.play()
