class_name PlayerSelection
extends Control

signal selected

var player:Player

func _ready():
	player = Player.new()
	$Characters/ChiefCard.connect("gui_input", self, "set_player_chief")
	$Characters/DashCard.connect("gui_input", self, "set_player_dash")
	$Characters/SlippyCard.connect("gui_input", self, "set_player_slippy")
	$Characters/StanleyCard.connect("gui_input", self, "set_player_stanley")

func set_player_dash(event):
	if (event.is_action("ui_accept")):
		player.top_speed = 10.0
		select_player()
	
func set_player_chief(event):
	if (event.is_action("ui_accept")):
		player.infection_rate = -0.5
		select_player()

func set_player_slippy(event):
	if (event.is_action("ui_accept")):
		player.friction = 0.1
		select_player()

func set_player_stanley(event):
	if (event.is_action("ui_accept")):
		select_player()
	
func select_player():
	emit_signal("selected", player)
