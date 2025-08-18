extends Node

@onready var terrain_layer: TerrainLayer = get_parent()
@onready var noise_generator := FastNoiseLite.new()


func _ready():
    noise_generator.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
    noise_generator.frequency = .21

    generate_chunk(0)
    generate_chunk(1)


func generate_chunk(y_index = 0):
    var y_offset = y_index * ChunkTools.CHUNK_SIZE
    var placement_layer = generate_placement_layer(y_offset) 

    for pos in ChunkTools.chunk_range(): 
        if 1 <= placement_layer.getv(pos):
            terrain_layer.place_tile(pos.x, pos.y + y_offset)


func generate_placement_layer(y_offset) -> ChunkTools.ChunkArray:
    var layer = ChunkTools.ChunkArray.new()

    # first pass
    for pos in ChunkTools.chunk_range():
        var v = (noise_generator.get_noise_2d(pos.x, pos.y + y_offset) + 1) / 2
        if .5 <= v: 
            layer.setv(pos, 1)
    
    # second pass
    # TODO
    for pos in ChunkTools.chunk_range():
        if layer.getv(pos) == 0:
            continue
        
    return layer

