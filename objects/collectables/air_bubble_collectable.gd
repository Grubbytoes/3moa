extends BaseCollectable


func player_pickup(player: Player) -> void:
	player.master.add_air(10)
