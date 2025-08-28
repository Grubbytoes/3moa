extends Area2D


@export var damage := 10
@export var knockback_force := 40


func _enter_tree() -> void:
	body_entered.connect(on_body_entered)


func on_body_entered(body: Node2D):
	if body is Player:
		print("player hit hazard")
		var normal := global_position.direction_to(body.global_position)
		body.knockback(normal * knockback_force)
		GlobalEvents.add_air.emit(-damage)