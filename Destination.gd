class_name Destination
extends Area2D

signal reached

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body:Node):
	if (body.is_class("Player")):
		emit_signal("reached")

func get_class():
	return "Destination"

func is_class(name:String):
	return name == "Destination" or .is_class(name)
