class_name Cougher
extends Pedestrian

func _init():
	infection = 10.0
	infection_period = 0.35

func _ready():	
	infection_delay_timer.start(infection_phase)

	$Visualization/Sprite.modulate = infection_color

func _on_infection_timeout():
	var infector = infector_res.instance()
	infector.color = infection_color
	infector.position = global_position + 32.0 * direction
	infector.start_size = 1.5
	infector.end_size = 2.5
	infector.duration = 2.0
	get_parent().add_child(infector)
