class_name TerrainLayer
extends TileMapLayer


func hit_tile_at(point_of_collision: Vector2):
	var hit_tile_coords = Vector2i(
		floor(point_of_collision.x / 16),
		floor(point_of_collision.y / 16)
	)
	erase_cell(hit_tile_coords)