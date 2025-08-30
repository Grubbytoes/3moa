class_name NonPlayerCharacter
extends BaseCharacter


@export var max_health = 3

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


## A useful function which encapsulates damage and knockback
func take_hit(normal: Vector2, knockback_force = 1, damage = 1) -> bool:
	if !normal.is_normalized():
		printerr("take_hit normal param is not normalized!")

	if take_damage(damage) and 0 < health:
		knockback(normal * knockback_force)
		return true
	elif 0 >= health:
		die()
		return true
	
	return false


## takes damage, reducing health, if character is vulnerable
func take_damage(damage: int) -> bool:
	if !super.take_damage(damage):
		return false
	
	health -= damage
	return true
