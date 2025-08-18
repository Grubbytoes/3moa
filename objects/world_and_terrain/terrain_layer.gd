class_name TerrainLayer
extends TileMapLayer

const TILE_SIZE = 32

var tile_damage := {}


func place_tile(x, y, _type=0):
	#! for now this only places basic tiles, will improve on this
	set_cell(Vector2i(x, y), 0, Vector2i.ZERO)


func hit_tile_at(point_of_collision: Vector2):
	var hit_tile_coords = Vector2i(
		floor((point_of_collision.x - position.x) / TILE_SIZE),
		floor((point_of_collision.y - position.y) / TILE_SIZE)
	)
	var hit_tile := get_cell_tile_data(hit_tile_coords)

	if !hit_tile:
		return
	
	var hardness: int = hit_tile.get_custom_data("hardness")

	if 0 >= hardness:
		erase_cell(hit_tile_coords)
	else:
		push_warning("hardness not fully implemented or tested")
		# 1. see if the tile is already in tile_damage, if not add it with hardness -1
		var damaged_hardness = tile_damage.get(hit_tile_coords)

		if damaged_hardness == null:
			tile_damage.set(hit_tile_coords, hardness-1)
		elif 0 < damaged_hardness:
			tile_damage.set(hit_tile_coords, damaged_hardness-1)
		else:
			erase_cell(hit_tile_coords)
			tile_damage.erase(hit_tile_coords)


func reset_tile_damage(key: Vector2i) -> bool:
	return tile_damage.erase(key)