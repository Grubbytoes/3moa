class_name BaseCollectable
extends RigidBody2D


func on_pickup_body_entered(body:Node2D) -> void:
	if !body.is_in_group("player"):
		return
	
	var player = body as Player
	if player:
		player_pickup(player)
		destroy()


func player_pickup(player: Player) -> void:
	pass


func destroy():
	queue_free()