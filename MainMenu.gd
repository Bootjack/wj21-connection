extends Control

var active_scene
var game_message_timer:Timer
var game_over_timer:Timer
var level_index = 0
var levels = [
	preload("res://Jason_3.tscn")
]

func _ready():
	game_message_timer = Timer.new()
	game_message_timer.one_shot = true
	add_child(game_message_timer)
	game_message_timer.connect("timeout", self, "_on_game_message_timeout")

	game_over_timer = Timer.new()
	game_over_timer.one_shot = true
	add_child(game_over_timer)
	game_over_timer.connect("timeout", self, "level_over")
	
	$Canvas/Menu/Buttons/StartButton.connect("button_up", self, "start_game")
	$Canvas/Menu/Buttons/NextButton.connect("button_up", self, "next_level")
	$Canvas/Menu/Buttons/MenuButton.connect("button_up", self, "main_menu")
	$Canvas/Menu/Buttons/QuitButton.connect("button_up", self, "quit_game")

func _unhandled_input(event):
	if (event.is_action_released("ui_cancel")):
		toggle_menu()

func _on_game_message_timeout():
	$Canvas/Result.visible = false
	get_tree().paused = false

func level_incomplete():
	$Canvas/Result/Label.text = "Need more TP!"
	$Canvas/Result.visible = true
	get_tree().paused = true
	game_message_timer.start(1.5)

func level_lost():
	$Canvas/Result/Label.text = "TP Lost!"
	$Canvas/Result.visible = true
	get_tree().paused = true
	toggle_restart()
	game_over_timer.start(2.5)

func level_over():
	$Canvas/Result.visible = false
	active_scene.disconnect("level_won", self, "level_won")
	active_scene.disconnect("level_lost", self, "level_lost")
	active_scene.disconnect("level_incomplete", self, "level_incomplete")
	$Canvas/Menu.visible = true
	self.remove_child(active_scene)

func level_won():
	$Canvas/Result/Label.text = "TP Success!"
	$Canvas/Result.visible = true
	$Canvas/Menu/Buttons/NextButton.disabled = false
	get_tree().paused = true
	toggle_restart()
	game_over_timer.start(2.5)

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
	start_level()

func quit_game():
	get_tree().quit()

func restart_level():
	level_over()
	start_level()

func start_game():
	$Canvas/Menu/Buttons/StartButton.text = "Restart"
	$Canvas/Menu/Buttons/StartButton.disconnect("button_up", self, "start_game")
	$Canvas/Menu/Buttons/StartButton.connect("button_up", self, "restart_level")
	start_level()

func start_level():
	get_tree().paused = false
	$Canvas/Menu/Buttons/NextButton.disabled = true
	$Canvas/Menu/Buttons/MenuButton.disabled = false
	active_scene = levels[level_index].instance()
	self.add_child(active_scene)
	active_scene.connect("level_won", self, "level_won")
	active_scene.connect("level_lost", self, "level_lost")
	active_scene.connect("level_incomplete", self, "level_incomplete")
	$Canvas/Menu.visible = false

func toggle_menu():
	get_tree().paused = true
	active_scene.get_node("HUD").toggle()
	active_scene.visible = !active_scene.visible
	$Canvas/Menu.visible = !$Canvas/Menu.visible

func toggle_restart():
	$Canvas/Menu/Buttons/StartButton.disconnect("button_up", self, "restart_level")
	$Canvas/Menu/Buttons/StartButton.connect("button_up", self, "start_level")
