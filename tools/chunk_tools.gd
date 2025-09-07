extends Node


const CHUNK_SIZE = 18
const CHUNK_AREA = CHUNK_SIZE ** 2


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