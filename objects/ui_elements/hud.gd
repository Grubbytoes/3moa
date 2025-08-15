extends Control

# Just for now, I am going to contain some of the actual game logic in the HUD script
# I don't think this'll be a great idea to scale with, but it'll help me prototype

# Just bare that in mind and make stuff as easy to decouple later

@onready var time_display = $TimeDisplay

var stopwatch_time: int = 0

func _ready():
    time_display.set_display(180, 0)