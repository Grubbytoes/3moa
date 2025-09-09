extends Level

@export var score_label: Label
@export var time_label: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var results_data := game_root.last_results
	var formatted_time = [floor(results_data.time / 60), results_data.time % 60]

	score_label.text = "SCORE : %06d" % results_data.score
	time_label.text = "TIME: %02d:%02d" % formatted_time
