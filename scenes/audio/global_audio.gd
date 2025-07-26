extends Node

@onready var click_sound: AudioStreamPlayer = $ClickSound
@onready var point_sound: AudioStreamPlayer = $PointSound
@onready var shuffle_sound: AudioStreamPlayer = $ShuffleSound

func play_click() -> void:
	click_sound.play()

func play_point() -> void:
	point_sound.play()
	
func play_shuffle() -> void:
	shuffle_sound.play()
