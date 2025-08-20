extends Node

@export var placement_threshold := .5

@onready var terrain_layer: TerrainLayer = get_parent()
@onready var noise_generator := FastNoiseLite.new()


func _ready():
	noise_generator.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	noise_generator.frequency = .21

	generate_chunk(0)
	generate_chunk(1)


func generate_chunk(y_index = 0):
	var y_offset = y_index * ChunkTools.CHUNK_SIZE

	generate_placement_layer(y_offset)
	ore_layer(y_offset)


func generate_placement_layer(y_offset):
	var layer = ChunkTools.ChunkArray.new()

	# first pass
	for pos in ChunkTools.chunk_range():
		# simple noise
		var v = (noise_generator.get_noise_2d(pos.x, pos.y + y_offset) + 1) / 2

		# increased towards the sides
		var distance_from_margin = min(pos.x, ChunkTools.CHUNK_SIZE - 1 - pos.x)
		if 3 > distance_from_margin:
			v += (3 - distance_from_margin) * .5

		if placement_threshold <= v:
			layer.setv(pos, 1)
	
	# second pass
	# TODO

	# Do the work
	for pos in ChunkTools.chunk_range():
		if 1 <= layer.getv(pos):
			terrain_layer.place_tile(pos + Vector2i(0, y_offset))


## Generates and places the ore layer
func ore_layer(y_offset: int, no_ore_veins := 3):
	while 0 < no_ore_veins:
		var rand_coord = ChunkTools.randcoord() + Vector2i(0, y_offset)
		if grow_ore_vein(rand_coord):
			no_ore_veins -= 1


## Attempts to grow an ore vein of the given richness at the given coordinate. Will only place ore on top of existing tiles, according to TerrainLayer
## Returns how many ore tiles were successfully placed. 0 means no ore was placed.
func grow_ore_vein(coord: Vector2i, richness := 3) -> int:
	var ore_placed = 0

	while ore_placed < richness and terrain_layer.place_ore(coord):
		ore_placed += 1
		coord = ChunkTools.simple_random_displace(coord)
	
	return ore_placed	
