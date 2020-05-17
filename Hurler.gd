class_name Hurler
extends Pedestrian

func _init():
	infection = 10.0
	infection_period = 4.0

func _ready():	
	infection_delay_timer.start(infection_phase)
	$Visualization/Sprite.modulate = infection_color

func _on_infection_timeout():
	var infector = infector_res.instance()
	infector.color = infection_color
	infector.height = 2.0
	infector.position = global_position + 96.0 * direction
	infector.rotation = atan2(direction.x, -direction.y)
	infector.start_size = 1.5
	infector.end_size = 1.5
	infector.duration = 2.0
	get_parent().add_child(infector)
	is_immune = true
	$Visualization/Sprite.play("Sick")
