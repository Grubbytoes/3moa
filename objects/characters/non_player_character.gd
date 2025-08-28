class_name NonPlayerCharacter
extends CharacterBody2D

signal death

@export var max_health = 3
@export var damage = 10


## The intended move direction of the character
var move_direction := Vector2.ZERO
var acceleration = 50
var slerp_movement = false
var movement_lerp_weight = 2


@onready var health = max_health

func move_character(delta) -> bool:
	var collided = move_and_slide()

	if 1 > velocity.distance_to(move_direction) and velocity != move_direction:
		velocity = move_direction
	elif slerp_movement:
		velocity = velocity.slerp(move_direction, movement_lerp_weight * delta)
	else:
		velocity = velocity.move_toward(move_direction, acceleration * delta)
		
	return collided


func projectile_hit():
	# todo would be nice to have a proper health and damage system here
	health -= 1
	
	if 0 >= health:
		die()


func die():
	queue_free()