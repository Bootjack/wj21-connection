class_name Player
extends Person

var inventory = []

func _init():
	friction = 0.3
	infection_rate = 0.0
	sprint_factor = 2.0
	top_speed = 4.0

func _process(delta):
	if (Input.is_action_pressed("left")):
		move_left()
	elif (Input.is_action_pressed("right")):
		move_right()

	if (Input.is_action_pressed("up")):
		move_up()
	elif (Input.is_action_pressed("down")):
		move_down()

	if (Input.is_action_just_pressed("jump")):
		jump()

	if (Input.is_action_just_pressed("sprint")):
		sprint()

func _on_picked_up(item:Node):
	inventory.append(item)

func get_class():
	return "Player"

func is_class(name:String):
	return name == "Player" or .is_class(name)
