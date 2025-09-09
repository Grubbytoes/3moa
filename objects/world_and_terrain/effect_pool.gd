extends ObjectPool


var packed_effects := {
	"tile_break" : preload("res://objects/effects/tile_break_particles.tscn")
}

var tile_break_particles: GPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# set up tile break emitters
	tile_break_particles = packed_effects["tile_break"].instantiate()
	add_child(tile_break_particles)


func tile_break(coords: Vector2i):
	var spawn_at = Vector2(coords * 32) + Vector2(16, 16)
	tile_break_particles.position = spawn_at
	tile_break_particles.restart()
