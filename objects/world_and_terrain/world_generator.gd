extends Node

signal enemy_spawned(coord: Vector2i, key: String)
signal item_spawned(coord: Vector2i, key: String)

@export var terrain_layer: TerrainLayer
@export var placement_threshold := .5

# TODO
const enemy_weights = [
	["floating", 1, 0],
	["chaser", 2, 4],
	["sleeper", 2, 6]
]

# TODO
const ore_weights = [
	["copper", 2, 0],
	["silver", 3, 4],
	["silver", 5, 8],
]

## This value determines how "serious" the generated chunks will be - ie high or low risk/reward.
## By default, this increments with each new chunk
var depth_score := 0

@onready var placement_noise := FastNoiseLite.new()
@onready var hardness_noise := FastNoiseLite.new()
@onready var noise_seed = randi()

func _ready():
	if not terrain_layer:
		printerr("terrain_layer has not been set for world generator!")

	placement_noise.seed = noise_seed
	placement_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	placement_noise.frequency = .21

	hardness_noise.seed = noise_seed
	hardness_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	hardness_noise.frequency = .14

	generate_chunk(0)
	generate_chunk(1)


func generate_chunk(y_index = 0):
	var y_offset = y_index * ChunkTools.CHUNK_SIZE

	placement_layer(y_offset)
	hardness_layer(y_offset)
	ore_layer(y_offset)
	enemy_layer(y_offset)
	bonus_layer(y_offset)

	depth_score += 1


func placement_layer(y_offset):
	var raw_placement_layer = _generate_raw_placement_layer(y_offset)
	
	# second pass
	# TODO

	# Do the work
	for pos in ChunkArray.range():
		if 1 <= raw_placement_layer.getv(pos):
			terrain_layer.place_tile(pos + Vector2i(0, y_offset))


## creates patches of harder and softer rock
func hardness_layer(y_offset: int):
	for pos in ChunkArray.range():
		pos += +Vector2i(0, y_offset)
		var cell_data = terrain_layer.get_cell_tile_data(pos)

		if !cell_data: continue

		var hardness_value = hardness_noise.get_noise_2dv(pos)

		if .25 < hardness_value:
			terrain_layer.place_tile(pos, 1)
	

## Generates and places the ore layer
func ore_layer(y_offset: int, no_ore_veins := 3):
	while 0 < no_ore_veins:
		var rand_coord = ChunkTools.randcoord() + Vector2i(0, y_offset)
		if _grow_ore_vein(rand_coord):
			no_ore_veins -= 1


func enemy_layer(y_offset: int):
	var enemy_score = 2 + floor(depth_score / 3)
	var rand_coord = _random_empty_cell(y_offset)

	while 0 < enemy_score:
		enemy_score = _spawn_enemy(rand_coord, enemy_score)
		rand_coord = _random_empty_cell(y_offset)
		

func bonus_layer(y_offset: int):
	var rand_coord = _random_empty_cell(y_offset)
	item_spawned.emit(rand_coord, "air bubble")


## Spawns an enemy with the given score 'budget', returns the new 'budget' after an enemy has been spawned.
func _spawn_enemy(coord, score) -> int:
	if 0 >= score:
		return 0

	enemy_spawned.emit(coord, "floating")
	return score - 1

## Attempts to grow an ore vein of the given richness at the given coordinate. Will only place ore on top of existing tiles, according to TerrainLayer
## Returns how many ore tiles were successfully placed. 0 means no ore was placed.
func _grow_ore_vein(coord: Vector2i, richness := 3) -> int:
	var ore_placed = 0

	while ore_placed < richness and terrain_layer.place_ore(coord):
		ore_placed += 1
		coord = ChunkTools.simple_random_displace(coord)
	
	return ore_placed


func _random_empty_cell(y_offset: int):
	var rand_coord = ChunkTools.randcoord() + Vector2i(0, y_offset)

	while !terrain_layer.is_cell_free(rand_coord):
		rand_coord = ChunkTools.randcoord() + Vector2i(0, y_offset)
	
	return rand_coord


func _generate_raw_placement_layer(y_offset: int) -> ChunkArray:
	var layer = ChunkArray.new()
	
	# first pass
	for pos in ChunkArray.range():
		# simple noise
		var v = (placement_noise.get_noise_2d(pos.x, pos.y + y_offset) + 1) / 2

		# increased towards the sides
		var distance_from_margin = min(pos.x, ChunkTools.CHUNK_SIZE - 1 - pos.x)
		if 3 > distance_from_margin:
			v += (3 - distance_from_margin) * .5

		if placement_threshold <= v:
			layer.setv(pos, 1)
	
	return layer
