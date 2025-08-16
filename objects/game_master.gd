class_name GameMaster
extends Node

signal time_tick()
signal game_ended()
signal score_update(new_score)
signal time_update(new_time)
signal air_update(new_air)

var time := 0
var air := 180
var score := 0

@onready var t: Timer = $Timer


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