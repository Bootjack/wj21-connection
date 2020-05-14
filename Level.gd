class_name Level
extends Node2D

signal level_won
signal level_lost

export var player_path:NodePath
export var destination_path:NodePath
export var objective_paths = []

var objectives = []
var player:Player

func _ready():
	player = get_node(player_path)
	get_node(destination_path).connect("reached", self, "_on_destination_reached")
	for path in objective_paths:
		objectives.append(get_node(path))

func objectives_met():
	for item in objectives:
		if (!player.inventory.has(item)):
			return false
	return true

func _on_destination_reached():
	if (objectives_met()):
		emit_signal("level_won")
