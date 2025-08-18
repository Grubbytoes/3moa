class_name TerrainLayer
extends TileMapLayer

static var TILE_SIZE = 32

# TODO it may be a good idea to pull this out to its own class or node
var tile_damage := {}
var damage_manager := DamageManager.new()


func _ready():
	add_child(damage_manager)


func place_tile(x, y, _type=0):
	#! for now this only places basic tiles, will improve on this
	set_cell(Vector2i(x, y), 0, Vector2i.ZERO)


# Registers a hit on the tile at the given coordinates (if one exists)
# Handles tile damage and destruction
func hit_tile_at(point_of_collision: Vector2):
	var hit_tile_coords = Vector2i(
		floor((point_of_collision.x - position.x) / TILE_SIZE),
		floor((point_of_collision.y - position.y) / TILE_SIZE)
	)
	var hit_tile := get_cell_tile_data(hit_tile_coords)

	if !hit_tile:
		return
	elif damage_manager.can_destroy_tile(hit_tile_coords):
		destroy_tile(hit_tile_coords)


func destroy_tile(coords):
	erase_cell(coords)


# This class is responsible for answering the question "is this tile destroyed yet" when it is hit with a projectile
# It also handles animations and effects for partially damaged tiles
class DamageManager extends Node:
	const crack_effect = preload("res://objects/effects/tile_crack.tscn")

	var damage_map := {}

	func can_destroy_tile(key_coords: Vector2i) -> bool:
		var damaged_hardness = damage_map.get(key_coords, get_initial_hardness(key_coords))
		
		if 0 < damaged_hardness:
			damage_map.set(key_coords, damaged_hardness - 1)
			return false
		else:
			damage_map.erase(key_coords)
			return true
	

	func reset_tile_damage(key_coords: Vector2i):
		damage_map.erase(key_coords)


	# returns the initial hardness of the tile at the key coordinates, or -1 if there is none
	func get_initial_hardness(key_coords: Vector2i) -> int:
		var terrain_layer: TerrainLayer = get_parent()
		var tile_data = terrain_layer.get_cell_tile_data(key_coords)
		
		if tile_data:
			return tile_data.get_custom_data("hardness")
		else:
			return -1