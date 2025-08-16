class_name HUD
extends Control

# Just for now, I am going to contain some of the actual game logic in the HUD script
# I don't think this'll be a great idea to scale with, but it'll help me prototype

# Just bare that in mind and make stuff as easy to decouple later

@onready var time_display = $TimeDisplay
@onready var score_display = $ScoreDisplay

var stopwatch_time: int = 0

func update_air(value):
	time_display.update_air(value)


func update_time(value):
	time_display.update_time(value)


func update_score(value):
	score_display.update_score(value)
