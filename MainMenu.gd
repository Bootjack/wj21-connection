extends Control

var active_scene

func _ready():
	$Canvas/Menu/Buttons/StartButton.connect("button_up", self, "start_game")
	$Canvas/Menu/Buttons/QuitButton.connect("button_up", self, "quit_game")

func _unhandled_input(event):
	if (event.is_action_released("ui_cancel")):
		tooggle_menu()

func quit_game():
	get_tree().quit()
	
func start_game():
	var jason_scene = preload("res://Jason.tscn")
	active_scene = jason_scene.instance()
	$Canvas/Menu.visible = false
	$Canvas/Menu/Buttons/StartButton.disabled = true
	self.add_child(active_scene)

func tooggle_menu():
	active_scene.visible = !active_scene.visible
	$Canvas/Menu.visible = !$Canvas/Menu.visible
