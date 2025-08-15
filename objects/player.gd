extends CharacterBody2D

const base_thrust = 150
const shot_recoil = 50
const max_speed = 200
const preloaded_projectile = preload("res://objects/player_projectile.tscn")

var is_shot_ready = true

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


func thrust(heading, delta) -> void:
    velocity += heading * base_thrust * delta


func shoot(heading) -> void:
    if !is_shot_ready:
        return

    var projectile := preloaded_projectile.instantiate() as PlayerProjectile
    projectile.launch(self.position, heading)
    add_sibling(projectile)
    velocity += -heading * shot_recoil
    
    is_shot_ready = false
    shot_timer.start()


func apply_drag(delta: float) -> void:
    if 1 > velocity.length():
        velocity = Vector2.ZERO
        return
    
    velocity = velocity.lerp(Vector2.ZERO, 1 * delta)
    

func clamp_velocity():
    if max_speed > velocity.length(): 
        return

    velocity = velocity.normalized() * max_speed


func shot_ready():
    is_shot_ready = true