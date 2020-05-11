class_name Pedestrian
extends KinematicBody2D

var infectiousness:float = 2.0

func _ready():
	$InfectionZone.connect("body_entered", self, "infect")
	$InfectionZone.connect("body_exited", self, "disinfect")

func disinfect(body:Node2D):
	if (body.is_class("Player")):
		body.emit_signal("disinfected", infectiousness)

func get_class():
	return "Pedestrian"

func infect(body:Node2D):
	if (body.is_class("Player")):
		body.emit_signal("infected", infectiousness)
	
func is_class(name:String):
	return name == "Pedestrian" or .is_class(name)
