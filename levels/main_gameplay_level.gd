extends Level


@onready var hud := get_node("UILayer/Hud") as HUD
@onready var player := get_node("Player") as Player
@onready var game_master := get_node("GameMaster") as GameMaster


func _ready():
	# get the HUD ready
	setup_hud()
	
	# get the camera ready
	cam.make_current()
	cam.reparent(player, false) # very quick and dirty but we move

	print("beep")


func setup_hud():
	# I feel like this may get tedious but bare with me
	# it's somehow less tedious than doing it in editor
	game_master.air_update.connect(hud.update_air)
	game_master.time_update.connect(hud.update_time)
	game_master.score_update.connect(hud.update_score)
