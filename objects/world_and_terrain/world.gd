extends Node2D

signal chunk_needed(chunk_count)

@export var watch_player: Player

var next_chunk_needed_at := ChunkTools.CHUNK_SIZE
var chunk_count = 2

func _physics_process(delta):
	if next_chunk_needed_at < watch_player.position.y:
		chunk_needed.emit(chunk_count)
		chunk_count += 1
		next_chunk_needed_at += ChunkTools.CHUNK_SIZE * 32
