extends Node2D


# This could be pulled out to its own resource ir
var items = {
	"ore" : preload("res://objects/collectables/score_collectable.tscn")
}

func drop_ore(coords: Vector2i):
	var spawn_ore_item_at = Vector2(coords * 32) + Vector2(16, 16)
	var ore_item = items["ore"].instantiate()
	ore_item.position = spawn_ore_item_at


	call_deferred("add_child", ore_item)