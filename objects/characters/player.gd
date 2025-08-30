class_name Player
extends BaseCharacter

signal exceeded_critical_velocity(has_exceeded: bool)

## The strength of thrust applied to the character when boosting, correlates to movement acceleration
const base_thrust = 150
## The strength of the recoil when firing
const shot_recoil = 35
## Max speed the character may reach
const max_velocity = 200
## Speed above which character will take damage from colliding
const critical_velocity = 120
## Bounce upon hitting a wall
const bounce = .8
## Amount of air lost when colliding above critical velocity
const collision_air_penalty = 10

var preloaded_projectile = preload("res://objects/characters/player_projectile.tscn")

var _is_shot_ready = true
var _is_above_critical_velocity = false


@onready var shot_timer: Timer = get_node("ShotTimer")


func _physics_process(delta: float) -> void:
	var mouse_heading = get_local_mouse_position().normalized()

	if Input.is_action_pressed("action_a"):
		thrust(mouse_heading, delta)
	else:
		apply_drag(delta)

	if Input.is_action_pressed("action_b"):
		shoot(mouse_heading)
	
	move_and_slide()
	check_velocity()

	for i in get_slide_collision_count():
		_on_collision(get_slide_collision(i))


func thrust(heading, delta) -> void:
	velocity += heading * base_thrust * delta


func shoot(heading) -> void:
	if !_is_shot_ready:
		return

	var projectile := preloaded_projectile.instantiate() as PlayerProjectile
	projectile.launch(self.position, heading)
	add_sibling(projectile)
	velocity += -heading * shot_recoil
	
	_is_shot_ready = false
	shot_timer.start()



func apply_drag(delta: float) -> void:
	if 1 > velocity.length():
		velocity = Vector2.ZERO
		return
	
	velocity = velocity.lerp(Vector2.ZERO, .8 * delta)


func check_velocity():
	if critical_velocity < velocity.length() and !_is_above_critical_velocity:
		_is_above_critical_velocity = true
		exceeded_critical_velocity.emit(true)
	elif critical_velocity > velocity.length() and _is_above_critical_velocity:
		_is_above_critical_velocity = false
		exceeded_critical_velocity.emit(false)


func shot_ready():
	_is_shot_ready = true


func take_hit(normal: Vector2, knockback_force = 1, damage = 1) -> bool:
	var super_take_hit = super.take_hit(normal, knockback_force, damage)

	if super_take_hit:
		print("taking %s air damage" % damage)
		GlobalEvents.add_air.emit(-damage)
		return true
	
	return false


func _on_collision(collision: KinematicCollision2D):
	var normal = collision.get_normal()

	if _is_above_critical_velocity:
		take_hit(normal, 50, collision_air_penalty)
	else:
		velocity = velocity.bounce(normal) * bounce
