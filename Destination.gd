extends Area2D

signal reached

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body:Node):
	print(body)
	if (body.is_class("Player")):
		emit_signal("reached")
