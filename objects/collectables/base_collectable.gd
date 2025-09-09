class_name BaseCollectable
extends RigidBody2D

const pickup_effect := preload("res://objects/effects/item_pickup_particles.tscn")

func _ready():
	#! naive
	var impulse = (Vector2.UP * 10).rotated(randf() * 2)
	apply_impulse(impulse)


func on_pickup_body_entered(body:Node2D) -> void:
	if !body.is_in_group("player"):
		return
	
	var player = body as Player
	if player:
		player_pickup(player)
		play_pickup_effect()
		destroy()


func player_pickup(player: Player) -> void:
	pass


func destroy():
	queue_free()


func play_pickup_effect():
	var instanced_effect = pickup_effect.instantiate() as GPUParticles2D
	instanced_effect.position = self.position
	add_sibling(instanced_effect)
	instanced_effect.finished.connect(instanced_effect.queue_free)
	instanced_effect.restart()
	