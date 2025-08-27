extends BaseCollectable


@export var air_value = 10


func player_pickup(player: Player) -> void:
	GlobalEvents.add_air.emit(air_value)
