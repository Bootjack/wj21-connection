class_name Carrier
extends Pedestrian

func _init():
	infection = 10.0

func _ready():
	$Visualization/Sprite.modulate = infection_color
	add_infector()
