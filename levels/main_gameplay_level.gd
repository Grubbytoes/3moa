extends Level


signal next_chunk_needed(chunk_no: int)

var hud: HUD
var next_chunk_needed_at := ChunkTools.CHUNK_SIZE
var chunk_count = 2

@onready var player := get_node("Player") as Player
@onready var game_master := get_node("GameMaster") as GameMaster


func _ready():
	# get the HUD ready
	setup_hud()

	# get the player ready
	player.master = game_master
	
	# get the camera ready
	cam.make_current()
	cam.reparent(player, false) # very quick and dirty but we move

	print("beep")


func _physics_process(delta):
	if next_chunk_needed_at < player.position.y:
		next_chunk_needed.emit(chunk_count)
		chunk_count += 1
		next_chunk_needed_at += ChunkTools.CHUNK_SIZE * 32


func setup_hud():
	var packed_hud := preload("res://objects/ui_elements/hud.tscn")

	hud = packed_hud.instantiate()
	ui_layer.add_child(hud)

	# I feel like this may get tedious but bare with me
	# it's somehow less tedious than doing it in editor
	game_master.air_update.connect(hud.update_air)
	game_master.time_update.connect(hud.update_time)
	game_master.score_update.connect(hud.update_score)
