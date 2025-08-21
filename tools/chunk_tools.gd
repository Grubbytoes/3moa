extends Node


const CHUNK_SIZE = 18
const CHUNK_AREA = CHUNK_SIZE ** 2


func chunk_range() -> ChunkIterator:
	return ChunkIterator.new()


func randcoord():
	return Vector2i(
		randi() % CHUNK_SIZE,
		randi() % CHUNK_SIZE
	)


## returns a copy of the vector shifted in a random direction
func simple_random_displace(v: Vector2i, include_diagonals = false) -> Vector2i:
	var r := randi() % 4
	var d := Vector2i.ZERO

	if r % 2 == 0:
		d.x += 1
	else:
		d.y += 1

	if 2 <= r:
		d *= -1
	
	if include_diagonals:
		push_warning("diagonals not yet supported in simple_random_displace")
	
	return v + d


class ChunkArray:
	var _core_array := PackedInt32Array()

	func _init(initial = 0):
		_core_array.resize(CHUNK_AREA)
		_core_array.fill(initial)
	
	func getv(pos: Vector2i):
		return _core_array[_vector_to_idx(pos)]

	func setv(pos: Vector2i, v):
		_core_array.set(_vector_to_idx(pos), v)

	func _vector_to_idx(pos: Vector2i) -> int:
		var i = pos.x + pos.y * CHUNK_SIZE
		
		if i >= CHUNK_AREA:
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

		if 0 == value.x % CHUNK_SIZE:
			value.x = 0
			value.y += 1
		
		return CHUNK_SIZE > value.y