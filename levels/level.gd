class_name Level
extends Node2D

var hud: HUD

@onready var cam := get_node("Cam") as Camera2D
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


func setup_hud():
	var ui_layer := $UILayer as Node
	var packed_hud := preload("res://objects/ui_elements/hud.tscn")

	hud = packed_hud.instantiate()
	ui_layer.add_child(hud)

	# I feel like this may get tedious but bare with me
	# it's somehow less tedious than doing it in editor
	game_master.air_update.connect(hud.update_air)
	game_master.time_update.connect(hud.update_time)
	game_master.score_update.connect(hud.update_score)
