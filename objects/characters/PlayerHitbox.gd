extends Area2D

##! Currently, this class doesn't do anything :)

func _enter_tree() -> void:
	body_entered.connect(on_body_entered)


func on_body_entered(body: Node2D):
	pass