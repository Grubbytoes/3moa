extends Node

const CHUNK_SIZE = 18

@export var noise_zoom = 1

@onready var terrain_layer: TerrainLayer = get_parent()
@onready var noise_generator := FastNoiseLite.new()

func _ready():
    print("just testing")
    noise_generator.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
    generate_chunk(0)
    generate_chunk(1)


func generate_chunk(y_index = 0):  
    print("Generating chunk %s" % y_index)

    for x in range(CHUNK_SIZE): 
        for false_y in range(CHUNK_SIZE):
            var y = false_y + (CHUNK_SIZE * y_index)
            var v = (noise_generator.get_noise_2d(x * noise_zoom, y * noise_zoom) + 1) / 2

            if .5 <= v: 
                terrain_layer.place_tile(x, y)