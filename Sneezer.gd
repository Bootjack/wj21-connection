class_name Sneezer
extends Pedestrian

func _init():
	infection = 10.0
	infection_period = 3.0

func _ready():
	infection_delay_timer.start(infection_phase)

	$Visualization/Sprite.modulate = infection_color

func _on_infection_timeout():
	var infector = infector_res.instance()
	infector.color = infection_color
	infector.position = global_position
	infector.start_size = 2.0
	infector.end_size = 5.0
	infector.duration = 1.0
	get_parent().add_child(infector)
	is_immune = true
	$Visualization/Sprite.play("Sick")
