extends Node2D

var levels: Array[PackedScene] = [
    preload("res://levels/test_level.tscn"),
    preload("res://levels/terrain_gen.tscn")
]
var current_level: Level = null

@onready var level_stage = get_node("LevelStage") as Node

func _ready():
    current_level = levels[0].instantiate()
    level_stage.add_child(current_level)   
