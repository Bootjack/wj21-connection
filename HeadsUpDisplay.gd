extends CanvasLayer

export var player_path:NodePath

var color_healthy = Color(0.313726, 0.662745, 0.098039)
var color_warning = Color(1, 0.867188, 0)
var color_infected = Color(0.660156, 0.04455, 0.04455)
var gradient:Gradient
var player:Player
var tolerance = 500.0

func _ready():
	$Control/InfectionBar.max_value = tolerance
	player = get_node(player_path)
	_init_gradient()

func _process(delta):
	var ratio = clamp(player.infection / tolerance, 0.0, 1.0)
	$Control/InfectionBar.tint_progress = gradient.interpolate(1.0 - ratio)
	$Control/InfectionBar.value = (1.0 - ratio) * tolerance

func _init_gradient():
	gradient = Gradient.new()
	gradient.set_color(0, color_infected)
	gradient.set_color(1, color_healthy)
	gradient.add_point(0.5, color_healthy)
	gradient.add_point(0.3, color_warning)
	gradient.add_point(0.1, color_infected)

