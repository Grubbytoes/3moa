class_name ChunkArray
extends Resource

var _core_array := PackedInt32Array()

static func range() -> ChunkIterator:
	return ChunkIterator.new() 


func _init(initial = 0):
	_core_array.resize(ChunkTools.CHUNK_AREA)
	_core_array.fill(initial)


func getv(pos: Vector2i):
	return _core_array[_vector_to_idx(pos)]


func setv(pos: Vector2i, v):
	_core_array.set(_vector_to_idx(pos), v)


func _vector_to_idx(pos: Vector2i) -> int:
	var i = pos.x + pos.y * ChunkTools.CHUNK_SIZE
	
	if i >= ChunkTools.CHUNK_AREA:
		printerr("%s is out of bounds for ChunkArray" % pos)
		return -1
	
	return i


class ChunkIterator:
	var value: Vector2i

	func _iter_init(_iter: Array) -> bool:
		value = Vector2i.ZERO

		return true
	
	func _iter_get(_iter: Variant) -> Variant:
		return value
	
	func _iter_next(_iter: Array) -> bool:
		value.x += 1

		if 0 == value.x % ChunkTools.CHUNK_SIZE:
			value.x = 0
			value.y += 1
		
		return ChunkTools.CHUNK_SIZE > value.y