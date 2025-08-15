extends Control

@onready var air_remaining_label: Label = get_node("VBoxContainer/AirRemaining")
@onready var stopwatch_label: Label = get_node("VBoxContainer/Stopwatch")

func set_display(a: int, t: int):
    var air_minutes = floor(a / 60)
    var air_seconds = a % 60
    var time_minutes = floor(t / 60)
    var time_seconds = t % 60

    air_remaining_label.text = "%02d:%02d" % [air_minutes, air_seconds]
    stopwatch_label.text = "%02d:%02d" % [time_minutes, time_seconds]