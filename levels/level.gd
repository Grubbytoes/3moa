class_name Level
extends Node2D

signal level_ended

@onready var ui_layer := $UILayer as Node
@onready var game_root := get_parent().get_parent() as Game
@onready var cam := get_node("Cam") as Camera2D


func switch_level(key):
	game_root.switch_level(key)


func end_level():
	level_ended.emit()
	queue_free()
