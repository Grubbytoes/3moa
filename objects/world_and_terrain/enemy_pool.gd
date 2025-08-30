extends Node2D

const max_enemy_count = 5

var packed_enemies = {
	"dummy": preload("res://objects/characters/dummy_enemy.tscn"),
	"floating": preload("res://objects/characters/floating_enemy.tscn")
}


func spawn_enemy(coords: Vector2i, key: String):
	var spawn_position = Vector2(coords * 32) + Vector2(16, 16)
	var new_enemy = packed_enemies[key].instantiate()

	# Set up the enemy
	new_enemy.position = spawn_position

	# Add child (careful not to overcrowd)
	add_child(new_enemy)
	if max_enemy_count < get_child_count():
		var enemy_to_delete = get_child(0)
		remove_child(enemy_to_delete)
		enemy_to_delete.queue_free()
