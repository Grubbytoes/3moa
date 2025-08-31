class_name NonPlayerCharacter
extends BaseCharacter


@export var max_health = 3

var slerp_movement = false
var movement_lerp_weight = 2


@onready var health = max_health


## * OVERRIDE
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


## * OVERRIDE
## takes damage, reducing health, if character is vulnerable
func take_damage(damage: int) -> bool:
	if !super.take_damage(damage):
		return false
	
	health -= damage
	return true


func move_and_accelerate(direction: Vector2, delta: float, acceleration = 50) -> bool:
	var collided = move_and_slide()

	if 1 > velocity.distance_to(direction) and velocity != direction:
		velocity = direction
	else:
		velocity = velocity.move_toward(direction, acceleration * delta)
		
	return collided


func move_and_slerp(direction: Vector2, delta: float, weight = 1) -> bool:
	var collided = move_and_slide()

	if 1 > velocity.distance_to(direction) and velocity != direction:
		velocity = direction
	else:
		velocity = velocity.slerp(direction, weight * delta)
		
	return collided