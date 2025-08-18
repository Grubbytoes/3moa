extends Node


const CHUNK_SIZE = 18
const CHUNK_AREA = CHUNK_SIZE ** 2


func chunk_range() -> ChunkIterator:
	return ChunkIterator.new()


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