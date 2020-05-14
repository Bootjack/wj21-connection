extends Control

var active_scene
var level_index = 0
var levels = [preload("res://Jason.tscn")]

func _ready():
	$Canvas/Menu/Buttons/StartButton.connect("button_up", self, "start_game")
	$Canvas/Menu/Buttons/QuitButton.connect("button_up", self, "quit_game")

func _unhandled_input(event):
	if (event.is_action_released("ui_cancel")):
		toggle_menu()

func level_lost():
	level_over()

func level_over():
	active_scene.disconnect("level_won", self, "level_won")
	active_scene.disconnect("level_lost", self, "level_lost")
	$Canvas/Menu.visible = true
	$Canvas/Menu/Buttons/StartButton.disabled = false
	self.remove_child(active_scene)

func level_won():
	print("level won!")
	level_index += 1
	level_over()

func quit_game():
	get_tree().quit()
	
func start_game():
	$Canvas/Menu.visible = false
	$Canvas/Menu/Buttons/StartButton.disabled = true
	active_scene = levels[level_index].instance()
	self.add_child(active_scene)
	active_scene.connect("level_won", self, "level_won")
	active_scene.connect("level_lost", self, "level_lost")

func toggle_menu():
	active_scene.visible = !active_scene.visible
	$Canvas/Menu.visible = !$Canvas/Menu.visible
