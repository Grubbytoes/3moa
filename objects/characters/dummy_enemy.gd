extends Node2D


@onready var vision := $Vision


var slerp_movement = true
var movement_lerp_weight = 2

var target_velocity := Vector2.DOWN * 30
var velocity := Vector2.ZERO


func _physics_process(delta):
	move(delta)
	

func turn():
	var angle = (randf() + .5) * PI
	target_velocity = target_velocity.rotated(angle)
	vision.rotate(angle)


func move(delta: float):
	position += velocity * delta

	if 1 > velocity.distance_to(target_velocity) and velocity != target_velocity:
		velocity = target_velocity
	elif slerp_movement:
		velocity = velocity.slerp(target_velocity, movement_lerp_weight * delta)
	else:
		velocity = velocity.lerp(target_velocity, movement_lerp_weight * delta)
		

func _on_vision_body_entered(body:Node2D) -> void:
	turn()
