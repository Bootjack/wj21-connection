class_name Pickup
extends Node2D

export var elevation:float = 0.0

func _ready():
	$ProximityArea.connect("body_entered", self, "on_body_entered")
	$ProximityArea.translate(Vector2(0, 26 * elevation))

func on_body_entered(body:Node):
	if (body.is_class("Player")):
		body.emit_signal("picked_up", self)
		$ProximityArea.collision_layer = 0
		$ProximityArea.collision_mask = 0
		visible = false
		var musicNode = $"AudioStreamPlayer2D"
		musicNode.play()

func get_class():
	return "Pickup"
	
func is_class(name:String):
	return name == "Pickup" or .is_class(name)
