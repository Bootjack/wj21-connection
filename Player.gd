class_name Player
extends Person

signal picked_up

var inventory = []

func _init():
	friction = 0.3
	infection_rate = 0.0
	sprint_factor = 2.0
	tolerance = 32.0
	top_speed = 4.0

func _ready():
	connect("picked_up", self, "_on_picked_up")

func _on_picked_up(item:Node):
	inventory.append(item)

func get_class():
	return "Player"

func handle_movement():
	var parent = .handle_movement()
	
	var movement = Vector2.ZERO

	if (Input.is_action_pressed("left")):
		movement += Vector2(-1.0, 0.0)
	elif (Input.is_action_pressed("right")):
		movement += Vector2(1.0, 0.0)
		
	if (Input.is_action_pressed("up")):
		movement += Vector2(0.0, -1.0)
	elif (Input.is_action_pressed("down")):
		movement += Vector2(0.0, 1.0)

	if (Input.is_action_just_pressed("jump")):
		jump()
		var musicNode = $"jump"
		musicNode.play()
	if (Input.is_action_just_pressed("sprint")):
		sprint()
		var musicNode = $"run"
		musicNode.play()	
	if (movement.length() > 0.0):
		move(movement)

	parent.resume()

func hurt():
	$Visualization/Sprite.disconnect("animation_finished", self, "idle")
	$Visualization/Sprite.modulate = Color(0.521569, 0.701961, 0.07451)
	$Visualization/Sprite.play("Hurt")

func is_class(name:String):
	return name == "Player" or .is_class(name)

func unhurt():
	$Visualization/Sprite.connect("animation_finished", self, "idle")
	$Visualization/Sprite.modulate = Color.white
	$Visualization/Sprite.play("Idle")
