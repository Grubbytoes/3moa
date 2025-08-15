class_name Level
extends Node2D

var hud: HUD

@onready var cam := get_node("Cam") as Camera2D
@onready var player := get_node("Player") as Player
@onready var game_master := get_node("GameMaster") as GameMaster

func _ready():
	# get the HUD ready
	var ui_layer := $UILayer as Node
	var packed_hud := preload("res://objects/ui_elements/hud.tscn")
	hud = packed_hud.instantiate()
	ui_layer.add_child(hud)
	
	# get the camera ready
	cam.make_current()
	cam.reparent(player, false)# very quick and dirty but we move

	print("beep")
