extends Node2D


var packed_enemies = {
	"dummy": preload("res://objects/characters/dummy_enemy.tscn"),
	"floating": preload("res://objects/characters/floating_enemy.tscn")
}


func spawn_enemy(coords: Vector2i, key: String):
	var spawn_position = Vector2(coords * 32) + Vector2(16, 16)
	var new_enemy = packed_enemies[key].instantiate()

	new_enemy.position = spawn_position
	add_child(new_enemy)
