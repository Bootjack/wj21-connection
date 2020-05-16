class_name Pedestrian
extends Person

export var direction:Vector2 = Vector2.ZERO
export var distance:float = 0.0
export var infectiousness:float = 2.0
export var wait_time:float = 0.0

var reference_point:Vector2
var is_waiting:bool = false
var wait_timer:Timer

func _ready():
	reference_point = global_position
	
	wait_timer = Timer.new()
	wait_timer.one_shot = true
	add_child(wait_timer)
	wait_timer.connect("timeout", self, "_on_wait_timeout")

	$InfectionZone.connect("body_entered", self, "infect")
	$InfectionZone.connect("body_exited", self, "disinfect")

func _on_wait_timeout():
	is_waiting = false
	reference_point = global_position
	turn_around()

func disinfect(body:Node2D):
	if (body.is_class("Player")):
		body.emit_signal("disinfected", infectiousness)

func get_class():
	return "Pedestrian"

func handle_movement():
	var parent = .handle_movement()

	if (global_position.distance_to(reference_point) < distance):
		move(direction)
	elif (!is_waiting):
		is_waiting = true
		wait()
	
	parent.resume()

func infect(body:Node2D):
	if (body.is_class("Player")):
		body.emit_signal("infected", infectiousness)
	
func is_class(name:String):
	return name == "Pedestrian" or .is_class(name)
	
func turn_around():
	direction *= -1
	
func wait():
	wait_timer.start(wait_time)
