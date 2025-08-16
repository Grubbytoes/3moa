extends BaseCollectable


@export var score_value = 10


func player_pickup(player: Player) -> void:
	player.master.add_score(score_value)
