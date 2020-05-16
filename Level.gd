class_name Level
extends Node2D

signal level_won
signal level_lost

export var destination_path:NodePath
export var objective_paths = []

export var tilemap_paths = []
export var tilemap_heights = []

var camera:TrackingCamera
var hud:HeadsUpDisplay
var objectives = []
var player:Player
var tilemaps = []

func _ready():
	if (!player):
		player = $YSort/Player
	
	for path in tilemap_paths:
		var node = get_node(path)
		tilemaps.append(node)
	
	player.tilemaps = tilemaps
	player.tilemap_heights = tilemap_heights
	
	for pedestrian in $YSort/Pedestrians.get_children():
		pedestrian.tilemaps = tilemaps
		pedestrian.tilemap_heights = tilemap_heights
	
	camera = TrackingCamera.new()
	camera.target = player
	add_child(camera)
	camera.make_current()
	
	hud = preload("res://HUD.tscn").instance()
	hud.player = player
	add_child(hud)
	
	get_node(destination_path).connect("reached", self, "_on_destination_reached")
	for path in objective_paths:
		objectives.append(get_node(path))

func _process(_delta:float):
	if (player.infection >= player.tolerance):
		emit_signal("level_lost")

func _on_destination_reached():
	if (objectives_met()):
		emit_signal("level_won")

func get_class():
	return "Level"

func is_class(name:String):
	return name == "Level" or .is_class(name)

func modify_player(attributes:Dictionary):
	if (attributes["friction"]):
		player.friction = attributes["friction"]
	if (attributes["infection_rate"]):
		player.infection_rate = attributes["infection_rate"]
	if (attributes["top_speed"]):
		player.top_speed = attributes["top_speed"]

func objectives_met():
	for item in objectives:
		if (!player.inventory.has(item)):
			return false
	return true
