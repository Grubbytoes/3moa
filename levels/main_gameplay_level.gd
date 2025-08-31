extends Level


@onready var hud := get_node("UILayer/Hud") as HUD
@onready var player := get_node("Player") as Player
@onready var session_master := get_node("SessionMaster") as SessionMaster


func _ready():
	# get the HUD ready
	link_hud()
	
	# get the camera ready
	cam.make_current()
	cam.reparent(player, false) # very quick and dirty but we move

	print("beep")


## Links the session master to the HUD, as well as any other necessary incoming or
## outgoing signals necessary for the HUD to to it's job
func link_hud():
	# I feel like this may get tedious but bare with me
	# it's somehow less tedious than doing it in editor
	session_master.air_update.connect(hud.update_air)
	session_master.time_update.connect(hud.update_time)
	session_master.score_update.connect(hud.update_score)
