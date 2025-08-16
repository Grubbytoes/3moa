extends Control

@onready var air_remaining_label: Label = get_node("VBoxContainer/AirRemaining")
@onready var stopwatch_label: Label = get_node("VBoxContainer/Stopwatch")


func update_air(value):
    var thing = [floor(value / 60), value % 60]
    air_remaining_label.text = "%02d:%02d" % thing


func update_time(value):
    var thing = [floor(value / 60), value % 60]
    stopwatch_label.text = "%02d:%02d" % thing