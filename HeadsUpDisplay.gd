extends Control

export var player_path:NodePath

var player:Player
var stylebox:StyleBoxFlat
var tolerance = 500.0

func _ready():
	$InfectionBar.max_value = tolerance
	player = get_node(player_path)
	stylebox = StyleBoxFlat.new()

func _process(delta):
	var ratio = player.infection / tolerance
	$InfectionBar.tint_progress = Color(ratio, 1.0 - ratio, 0.0)
	$InfectionBar.value = player.infection
