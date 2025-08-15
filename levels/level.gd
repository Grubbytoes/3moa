class_name Level
extends Node2D

@onready var cam := get_node("Cam") as Camera2D

func _ready():
    cam.enabled = true
    cam.make_current()
    print("beep")