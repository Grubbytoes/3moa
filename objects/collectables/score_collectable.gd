extends BaseCollectable


@export var score_value = 10


func player_pickup(player: Player) -> void:
	GlobalEvents.add_score.emit(score_value)
