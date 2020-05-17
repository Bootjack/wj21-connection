class_name Infection
extends Node2D

export var duration:float = 2.0
export var growth:float = 0.0
export var infectiousness:float = 2.0
export var size:float = 1.0

var strength:float = 1.0

const base_radius:float = 32.0

func _ready():
	$InfectionZone.connect("body_entered", self, "infect")

func _process(delta:float):
	size += growth / delta
	strength -= delta / duration
	$InfectionZone/TextureShape.material.set_shader_param("strength", 0.5)
	$InfectionZone/TextureShape.scale = Vector2(size, size)
	$InfectionZone/CollisionShape2D.shape.radius = base_radius * size

func infect(body:Node2D):
	if (body.is_class("Player")):
		body.emit_signal("infected", infectiousness)
