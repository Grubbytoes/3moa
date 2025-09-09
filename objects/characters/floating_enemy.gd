extends NonPlayerCharacter

## The intended move direction of the character
var move_direction := Vector2.ZERO

@onready var vision = get_node("Vision") as Area2D

func _ready():
	move_direction = Vector2.DOWN * 45
	vision.body_entered.connect(random_turn.unbind(1))


func _physics_process(delta):
	var collided_on_move = move_and_accelerate(move_direction, delta, 50)
	
	if collided_on_move:
		random_turn()


## Turns this enemy a random angle between 90 and 270 degrees
func random_turn():
	var angle = (randf() + .5) * PI
	move_direction = move_direction.rotated(angle)
	vision.rotate(angle)