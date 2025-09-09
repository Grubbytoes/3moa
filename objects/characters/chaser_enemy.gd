extends NonPlayerCharacter


enum State {IDLE, CHASING, RESTING}

var speed = 200
var state := State.IDLE
var target_position := Vector2.ZERO

@onready var vision := $Vision as Area2D
@onready var chase_timer := $ChaseTimer as Timer


func _ready():
	chase_timer.timeout.connect(chase_timeout)


func _physics_process(delta):
	if state == State.IDLE:
		idle(delta)
	elif state == State.CHASING:
		chase(delta)
	elif state == State.RESTING:
		rest(delta)


func chase(delta: float):
	if !target:
		return
	
	move_and_accelerate(position.direction_to(target_position) * speed, delta, 400)


func idle(delta: float):
	move_and_decelerate(delta)


func rest(delta: float):
	move_and_decelerate(delta, 400)


func body_entered_vision(body: Node2D):
	if body is Player:
		target = body
		target_position = target.position
		state = State.CHASING
		chase_timer.start(2)
	

func chase_timeout():
	if state == State.CHASING:
		state = State.RESTING
		chase_timer.start(2)
	elif state == State.RESTING:
		state = State.CHASING
		target_position = target.position
		chase_timer.start(2)
