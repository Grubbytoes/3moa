class_name SessionMaster
extends Node
## Responsible for managing the logic of a single 'run' or session of the game
## Designed to be the single point of reference for resources, time, score etc.
## As well as a central point of contact for communications (player to ui etc) and signals to minimize coupling

signal time_tick()
signal game_ended()
signal score_update(new_score)
signal time_update(new_time)
signal air_update(new_air)

var time := 0
var air := 180
var score := 0

@onready var t: Timer = $Timer


func _enter_tree() -> void:
	GlobalEvents.add_air.connect(add_air)
	GlobalEvents.add_score.connect(add_score)


func _ready():
	t.timeout.connect(tick)
	t.start(1)


func add_score(s: int):
	score += s
	score_update.emit(score)


func add_air(a: int):
	air += a
	air_update.emit(air)


func tick():
	time += 1
	air -= 1

	time_tick.emit()
	time_update.emit(time)
	air_update.emit(air)

	if 0 >= air:
		end_game()
	else:
		t.start(1)


func end_game():
	print("Game over, from the game master!!")
	t.queue_free()
	game_ended.emit()