class_name PlayerProjectile
extends Node2D

const speed = 540
const knockback_force = 60

var packed_impact_particles := preload("res://objects/effects/impact_particles.tscn")
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

	if body is NonPlayerCharacter:
		var hit_character := body as NonPlayerCharacter
		var normal := global_position.direction_to(hit_character.global_position)
		hit_character.take_hit(normal, knockback_force)

	if body is TerrainLayer:
		var terrain_layer := body as TerrainLayer
		var point_of_collision = position + (velocity.normalized() * (radius + 1))
		terrain_layer.hit_tile_at(point_of_collision)

	destroy_projectile()


func destroy_projectile():
	var impact_particles = packed_impact_particles.instantiate() as GPUParticles2D
	impact_particles.restart()
	impact_particles.finished.connect(impact_particles.queue_free)
	impact_particles.position = self.position
	impact_particles.rotation = velocity.angle() - PI
	add_sibling(impact_particles)
	queue_free()
