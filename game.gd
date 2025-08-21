class_name Game
extends Node2D

var loaded_levels := {
    "main_gameplay": preload("res://levels/main_gameplay_level.tscn"),
}
var current_level: Level = null

@onready var level_stage = get_node("LevelStage") as Node

func _ready():
    stage_level("main_gameplay")


func stage_level(key: String) -> bool:
    var new_level_packed = loaded_levels.get(key)
    var new_level: Level

    if !new_level_packed:
        printerr("Level of key %s does not exist, it may not have been loaded" % key)
        return false
    
    if current_level:
        level_stage.remove_child(current_level)
        current_level.end_level()
    
    new_level = new_level_packed.instantiate()
    level_stage.add_child(new_level)
    current_level = new_level

    return true

