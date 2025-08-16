extends Control


@onready var score_label = get_node("Score") as Label


func update_score(value):
	score_label.text = "SCORE : %06d" % value