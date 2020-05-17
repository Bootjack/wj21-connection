class_name Pedestrian
extends Person

export var direction:Vector2 = Vector2.ZERO
export var distance:float = 0.0
export var infection_color = Color(0.356863, 1, 0.243137)
export var infection_phase:float = 0.0
export var wait_time:float = 0.0

var infection_delay_timer:Timer
var infection_period:float = 1.0
var infection_timer:Timer
var infector_res = preload("res://Infector.tscn")
var is_waiting:bool = false
var reference_point:Vector2
var wait_timer:Timer

func _init():
	top_speed = 2.0

func _ready():
	reference_point = global_position

	infection_delay_timer = Timer.new()
	infection_delay_timer.one_shot = true
	add_child(infection_delay_timer)
	infection_delay_timer.connect("timeout", self, "_on_infection_delay_timeout")

	infection_timer = Timer.new()
	add_child(infection_timer)
	infection_timer.connect("timeout", self, "_on_infection_timeout")

	wait_timer = Timer.new()
	wait_timer.one_shot = true
	add_child(wait_timer)
	wait_timer.connect("timeout", self, "_on_wait_timeout")
	
	_on_infected(0.0)

func _on_infection_delay_timeout():
	_on_infection_timeout()
	infection_timer.start(infection_period)

func _on_infected(infectiousness:float):
	var is_infected = infection >= tolerance
	._on_infected(infectiousness)
	if (!is_infected and infection >= tolerance):
		$Visualization/Sprite.modulate = infection_color
		add_infector()

func _on_infection_timeout():
	var infector = infector_res.instance()
	infector.position = global_position
	get_parent().add_child(infector)

func _on_wait_timeout():
	is_waiting = false
	reference_point = global_position
	turn_around()

func add_infector():
	var infector = infector_res.instance();
	infector.color = infection_color
	infector.position = Vector2(15.0, -15.0)
	infector.duration = 0.0
	infector.height = 1.0
	infector.start_size = 1.5
	infector.rotation = 0.5 * PI
	$Visualization.add_child(infector)

func get_class():
	return "Pedestrian"

func handle_movement():
	var parent = .handle_movement()

	if (global_position.distance_to(reference_point) < distance):
		move(direction)
	elif (wait_time > 0 and !is_waiting):
		is_waiting = true
		wait()
	
	parent.resume()
	
func is_class(name:String):
	return name == "Pedestrian" or .is_class(name)
	
func turn_around():
	direction *= -1
	
func wait():
	wait_timer.start(wait_time)
