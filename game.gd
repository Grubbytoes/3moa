class_name Game
extends Node2D

var loaded_levels := {
	"main_menu": load("res://levels/main_menu.tscn"),
	"main_gameplay": load("res://levels/main_gameplay_level.tscn"),
	"results_screen": load("res://levels/results_screen.tscn")
}
var current_level: Level = null
var last_results: ResultsData

@onready var level_stage = get_node("LevelStage") as Node

func _ready():
	switch_level("main_menu")


## Registers the score and time spend on the most recent session, ready for scores to be displayed
func register_last_results(score: int, time: int):
	print("registering results")
	print("Score of %s, time of %s" % [score, time])
	last_results = ResultsData.new(score, time)


## Switches to a new level. If a level is currently staged, that level is ended and removed
func switch_level(key: String) -> bool:
	var new_level_packed = loaded_levels.get(key)
	var new_level: Level

	# Make sure a new level exists
	if !new_level_packed:
		printerr("Level of key %s does not exist, it may not have been loaded" % key)
		return false
	
	# End the old level, and remove it from the tree
	if current_level:
		current_level.end_level()
		level_stage.remove_child(current_level)
	
	new_level = new_level_packed.instantiate()
	level_stage.add_child(new_level)
	current_level = new_level

	return true
