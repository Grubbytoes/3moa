extends NonPlayerCharacter


@onready var vision = get_node("Vision") as Area2D


func _ready():
	move_direction = Vector2.DOWN * 30
	vision.body_entered.connect(turn.unbind(1))


func _physics_process(delta):
	var collided_on_move = move_character(delta)
	
	if collided_on_move:
		turn()


func turn():
	var angle = (randf() + .5) * PI
	move_direction = move_direction.rotated(angle)
	vision.rotate(angle)