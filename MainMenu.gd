extends Control

var active_scene
var level_index = 0
var levels = [
	preload("res://Jason.tscn")
]
var player:Player
var player_selection:PlayerSelection
var player_selection_res = preload("res://PlayerSelection.tscn")

func _ready():	
	$Canvas/Menu/Buttons/StartButton.connect("button_up", self, "start_game")
	$Canvas/Menu/Buttons/NextButton.connect("button_up", self, "next_level")
	$Canvas/Menu/Buttons/MenuButton.connect("button_up", self, "main_menu")
	$Canvas/Menu/Buttons/QuitButton.connect("button_up", self, "quit_game")

func _unhandled_input(event):
	if (event.is_action_released("ui_cancel")):
		toggle_menu()

func _on_player_selected(selected_player:Player):
	player = selected_player
	remove_player_selection()
	start_level()

func add_player_selection():
	player_selection = player_selection_res.instance()
	$Canvas.add_child(player_selection)
	player_selection.connect("selected", self, "_on_player_selected")

func level_lost():
	level_over()

func level_over():
	active_scene.disconnect("level_won", self, "level_won")
	active_scene.disconnect("level_lost", self, "level_lost")
	$Canvas/Menu.visible = true
	self.remove_child(active_scene)

func level_won():
	$Canvas/Menu/Buttons/NextButton.disabled = false
	level_over()

func main_menu():
	level_index = 0
	$Canvas/Menu/Buttons/StartButton.text = "Start"
	$Canvas/Menu/Buttons/StartButton.disconnect("button_up", self, "restart_level")
	$Canvas/Menu/Buttons/StartButton.connect("button_up", self, "start_game")
	$Canvas/Menu/Buttons/NextButton.disabled = true
	$Canvas/Menu/Buttons/MenuButton.disabled = true
	level_over()

func next_level():
	level_index += 1
	if (level_index >= levels.size()):
		level_index = 0
	select_player()

func quit_game():
	get_tree().quit()

func remove_player_selection():
	remove_child(player_selection)
	player_selection.queue_free()

func restart_level():
	level_over()
	select_player()

func select_player():
	add_player_selection()
	$Canvas/Menu.visible = false

func start_game():
	$Canvas/Menu/Buttons/StartButton.text = "Restart"
	$Canvas/Menu/Buttons/StartButton.disconnect("button_up", self, "start_game")
	$Canvas/Menu/Buttons/StartButton.connect("button_up", self, "restart_level")
	select_player()

func start_level():
	$Canvas/Menu/Buttons/NextButton.disabled = true
	$Canvas/Menu/Buttons/MenuButton.disabled = false
	active_scene = levels[level_index].instance()
	active_scene.player = player
	self.add_child(active_scene)
	active_scene.connect("level_won", self, "level_won")
	active_scene.connect("level_lost", self, "level_lost")

func toggle_menu():
	active_scene.get_node("HUD").toggle()
	active_scene.visible = !active_scene.visible
	$Canvas/Menu.visible = !$Canvas/Menu.visible