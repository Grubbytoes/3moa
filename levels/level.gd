class_name Level
extends Node2D

@onready var ui_layer := $UILayer as Node
@onready var game_root := get_parent() as Game
@onready var cam := get_node("Cam") as Camera2D


func end_level():
	queue_free()
