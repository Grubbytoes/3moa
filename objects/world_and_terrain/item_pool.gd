extends Node2D


# This could be pulled out to its own resource ir
var packed_items = {
	"ore" : preload("res://objects/collectables/score_collectable.tscn")
}


func drop_item(coords: Vector2i, key: String):
	var spawn_item_at = Vector2(coords * 32) + Vector2(16, 16)
	var item = packed_items[key].instantiate()
	item.position = spawn_item_at

	call_deferred("add_child", item)