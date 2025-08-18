extends Node


const CHUNK_SIZE = 18
const CHUNK_AREA = CHUNK_SIZE ** 2


func chunk_range() -> ChunkIterator:
	return ChunkIterator.new()


class ChunkArray:
	var _core_array := PackedInt32Array()

	func _init(initial = 0):
		_core_array.resize(CHUNK_AREA)
		_core_array.fill(initial)
	
	func getv(pos: Vector2i):
		return _core_array[_idx(pos)]

	func setv(pos: Vector2i, v):
		_core_array.set(_idx(pos), v)

	func _idx(pos: Vector2i) -> int:
		var i = pos.x + pos.y * CHUNK_SIZE
		
		if i >= CHUNK_AREA:
			printerr("%s is out of bounds for ChunkArray" % pos)
		
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