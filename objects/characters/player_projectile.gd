class_name PlayerProjectile
extends Node2D

const speed = 540

var velocity = Vector2.ZERO

@export var radius: int = 6

func launch(from: Vector2, direction: Vector2) -> void:
	self.position = from
	velocity = direction.normalized()


func _physics_process(delta):
	self.position += velocity * speed * delta


func hit_body(body: Node2D) -> void:
	# For now we are just assuming we're hitting a tile
	# logic for enemies and items later

	var terrain_layer := body as TerrainLayer
	if !terrain_layer:
		return

	# as of now, this will not work with scrolling or offset tiles
	var point_of_collision = position + (velocity.normalized() * (radius + 1))
	terrain_layer.hit_tile_at(point_of_collision)

	destroy_projectile()


func destroy_projectile():
	queue_free()
