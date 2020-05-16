class_name HeadsUpDisplay
extends CanvasLayer

export var color_healthy = Color(0.313726, 0.662745, 0.098039)
export var color_warning = Color(1, 0.867188, 0)
export var color_infected = Color(0.660156, 0.04455, 0.04455)

var gradient:Gradient
var player:Player

func _ready():
	$Control/InfectionBar.max_value = player.tolerance
	_init_gradient()

func _process(delta):
	var ratio = clamp(player.infection / player.tolerance, 0.0, 1.0)
	$Control/InfectionBar.tint_progress = gradient.interpolate(1.0 - ratio)
	$Control/InfectionBar.value = (1.0 - ratio) * player.tolerance

func _init_gradient():
	gradient = Gradient.new()
	gradient.set_color(0, color_infected)
	gradient.set_color(1, color_healthy)
	gradient.add_point(0.5, color_healthy)
	gradient.add_point(0.3, color_warning)
	gradient.add_point(0.1, color_infected)

func get_class():
	return "HeadsUpDisplay"

func is_class(name:String):
	return name == "HeadsUpDisplay" or .is_class(name)

func toggle():
	$Control.visible = !$Control.visible
