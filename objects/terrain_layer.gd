class_name TerrainLayer
extends TileMapLayer


func hit_tile_at(point_of_collision: Vector2):
	var hit_tile_coords = Vector2i(
		floor((point_of_collision.x - position.x) / 16),
		floor((point_of_collision.y - position.y) / 16)
	)
	var hit_tile := get_cell_tile_data(hit_tile_coords)

	if !hit_tile:
		return

	# I think this is a rough way of doing it but we'll see
	var hardness: int = hit_tile.get_custom_data("hardness")

	if 0 >= hardness:
		erase_cell(hit_tile_coords)
	else:
		set_cell(hit_tile_coords, 2, Vector2i(0, hardness - 1))
