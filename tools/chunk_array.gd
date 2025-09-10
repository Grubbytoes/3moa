class_name ChunkArray
extends Resource

var _core_array := PackedInt32Array()

static func range() -> ChunkIterator:
	return ChunkIterator.new()


func _init(initial = 0):
	_core_array.resize(ChunkTools.CHUNK_AREA)
	_core_array.fill(initial)


func getv(pos: Vector2i, default = null):
	var idx = _vector_to_idx(pos)
	if 0 > idx:
		return default
	return _core_array[idx]


func setv(pos: Vector2i, v):
	var idx = _vector_to_idx(pos)
	if 0 > idx:
		return null
	_core_array.set(idx, v)


func get_neighbors(pos: Vector2i, include_corners = false):
	var neighbors = []

	for coord in get_neighboring_coords(pos, include_corners):
		var val = getv(coord)
		if !val: continue
		neighbors.append(val)
	
	return neighbors


func get_neighboring_coords(pos: Vector2i, include_corners = false):
	if not include_corners:
		return [
			pos + Vector2i.UP,
			pos + Vector2i.RIGHT,
			pos + Vector2i.DOWN,
			pos + Vector2i.LEFT,
		]
	else:
		return [
			pos + Vector2i.UP,
			pos + Vector2i.UP + Vector2i.RIGHT,
			pos + Vector2i.RIGHT,
			pos + Vector2i.RIGHT + Vector2i.DOWN,
			pos + Vector2i.DOWN,
			pos + Vector2i.DOWN + Vector2i.LEFT,
			pos + Vector2i.LEFT,
			pos + Vector2i.LEFT + Vector2i.UP,
		]


func _vector_to_idx(pos: Vector2i) -> int:
	var i = pos.x + pos.y * ChunkTools.CHUNK_SIZE
	
	if i >= ChunkTools.CHUNK_AREA or i < 0:
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