class_name TerrainLayer
extends TileMapLayer

signal item_dropped(coords: Vector2i, key: String)
signal tile_hit(coords: Vector2i)
signal tile_destroyed(coords: Vector2i)

static var TILE_SIZE = 32

# TODO it may be a good idea to pull this out to its own class or node
var tile_damage := {}
var damage_manager := DamageManager.new()
var effects_manager := EffectManager.new()

func _ready():
	add_child(damage_manager)
	add_child(effects_manager)


## Places a block of stone at the given coordinates
func place_tile(coord: Vector2i, type = 0):
	#! for now this only places basic tiles, will improve on this
	var atlas_coords = Vector2i.ZERO + Vector2i(type, 0)
	set_cell(coord, 0, atlas_coords)


## Places a block of ore at the given coordinates. will ONLY place ore on top of existing tiles, and will return false if it tries
## to place ore on an empty cell
func place_ore(coord: Vector2i, _type = 0) -> bool:
	#! for now very simple, only a single ore type
	var atlas_coords = get_cell_atlas_coords(coord)

	if atlas_coords == Vector2i(-1, -1):
		return false
	
	set_cell(coord, 1, atlas_coords)
	return true


## Registers a hit on the tile at the given coordinates (if one exists), handles tile damage and destruction
func hit_tile_at(point_of_collision: Vector2):
	var hit_tile_coords = Vector2i(
		floor((point_of_collision.x - position.x) / TILE_SIZE),
		floor((point_of_collision.y - position.y) / TILE_SIZE)
	)

	if damage_manager.can_destroy_tile(hit_tile_coords):
		destroy_tile(hit_tile_coords)


## Destroys the tile at the given coordinates, if one exist. If this is a special tile (like ore) the logic for that
## tiles destruction is triggered here
##
## Returns false if it tries to destroy and empty cell, otherwise true
func destroy_tile(coords) -> bool:
	var tile_data := get_cell_tile_data(coords)

	if tile_data == null:
		return false
		
	var item = tile_data.get_custom_data("item")
	
	if item:
		item_dropped.emit(coords, item)

	erase_cell(coords)
	effects_manager.destroy_tile_effect(coords)

	return true


func is_cell_free(coords: Vector2i) -> bool:
	return get_cell_source_id(coords) == -1


# This class is responsible for answering the question "is this tile destroyed yet" when it is hit with a projectile
# It also handles animations and effects for partially damaged tiles
class DamageManager extends Node:
	const crack_effect = preload("res://objects/effects/tile_crack.tscn")

	var damage_map := {}

	## Returns true of the tile at the given coordinates (if one exists) is sufficiently damaged
	## that it can be destroyed.
	func can_destroy_tile(key_coords: Vector2i) -> bool:
		var damaged_hardness = damage_map.get(key_coords, get_initial_hardness(key_coords))
		
		if 0 < damaged_hardness:
			damage_map.set(key_coords, damaged_hardness - 1)
			return false
		else:
			damage_map.erase(key_coords)
			return true
	

	## Resets the damage of the given tile - clearing references to it in the damage map
	func reset_tile_damage(key_coords: Vector2i):
		damage_map.erase(key_coords)


	## returns the initial hardness of the tile at the key coordinates, or -1 if there is none
	func get_initial_hardness(key_coords: Vector2i) -> int:
		var terrain_layer: TerrainLayer = get_parent()
		var tile_data = terrain_layer.get_cell_tile_data(key_coords)
		
		if tile_data:
			return tile_data.get_custom_data("hardness")
		else:
			return -1
		

# TODO
class EffectManager extends Node2D:
	func destroy_tile_effect(coords: Vector2i):
		pass
	
	func damage_tile_effect(coords: Vector2i):
		pass
