class_name BaseCharacter
extends CharacterBody2D

signal death

var _invulnerable = false


@onready var _invulnerability_timer := $InvulnerabilityTimer as Timer
@onready var _character_anim := $CharacterAnimation as AnimationPlayer


## starts the invulnerability period if the character is vulnerable
## designed to be overwritten/expanded!!
func take_damage(damage: int) -> bool:
	if is_invulnerable():
		return false
	if 1 > damage:
		return false
	
	_invulnerable_on(1)
	
	return true


## A useful function which encapsulates damage and knockback, returns true if damage is taken
func take_hit(normal: Vector2, knockback_force = 1, damage = 1) -> bool:
	if !normal.is_normalized():
		printerr("take_hit normal param is not normalized!")
	
	if take_damage(damage):
		knockback(normal * knockback_force)
		return true
	
	return false


func knockback(force: Vector2):
	velocity += force


func is_invulnerable():
	return _invulnerable


func _invulnerable_on(t: float):
	_invulnerable = true
	_character_anim.play("invulnerable")
	_invulnerability_timer.start(t)
	pass


func _invulnerability_off():
	_invulnerable = false
	_character_anim.stop()


func die():
	death.emit()
	queue_free()