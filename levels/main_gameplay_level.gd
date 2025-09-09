extends Level

var _paused := false

@onready var hud := get_node("UILayer/Hud") as HUD
@onready var pause_menu = get_node("UILayer/PauseMenu") as PauseMenu
@onready var player := get_node("World/Player") as Player
@onready var world := get_node("World")
@onready var session_master := get_node("SessionMaster") as SessionMaster


func _ready():
	# get the HUD ready
	link_hud()
	
	# get the camera ready
	cam.make_current()
	cam.reparent(player, false) # very quick and dirty but we move

	# connect the session master so that the game ends properly
	session_master.session_ended.connect(finish_session)

	print("beep")


func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		set_paused(!is_paused())


## Links the session master to the HUD, as well as any other necessary incoming or
## outgoing signals necessary for the HUD to to it's job
func link_hud():
	# I feel like this may get tedious but bare with me
	# it's somehow less tedious than doing it in editor
	session_master.air_update.connect(hud.update_air)
	session_master.time_update.connect(hud.update_time)
	session_master.score_update.connect(hud.update_score)


## Pauses or plays the world and player
func set_paused(p: bool):
	var new_process_mode: Node.ProcessMode

	if p:
		print("pausing!")
		new_process_mode = Node.PROCESS_MODE_DISABLED
	else:
		new_process_mode = Node.PROCESS_MODE_INHERIT

	player.process_mode = new_process_mode
	world.process_mode = new_process_mode

	pause_menu.visible = p
	
	_paused = p


func finish_session():
	var final_score = session_master.score
	var final_time = session_master.time

	game_root.register_last_results(final_score, final_time)
	switch_level("results_screen")


## Returns true if the world is paused
func is_paused() -> bool:
	return _paused
	