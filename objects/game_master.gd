class_name GameMaster
extends Node

signal on_tick()
signal on_game_end()

var time := 0
var air := 180
var score := 0

@onready var t: Timer = $Timer


func _ready():
	t.timeout.connect(tick)
	t.start(1)


func add_score(s: int):
	score += s


func add_air(a: int):
	air += a


func tick():
	time += 1
	air -= 1

	t.start(1)
	on_tick.emit()

	if 0 >= air:
		end_game()


func end_game():
	print("Game over, from the game master!!")
	t.queue_free()
	on_game_end.emit()