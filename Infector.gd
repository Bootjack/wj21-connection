class_name Infection
extends Node2D

export var duration:float = 2.0
export var growth:float = 1.0
export var height:float = 0.0
export var infectiousness:float = 2.0
export var size:float = 1.0

var color:Color = Color.white
var parent:Person
var strength:float = 1.0
var timer:Timer

const base_height:float = 32.0
const base_radius:float = 24.0

func _ready():
	if (duration > 0.0):
		timer = Timer.new()
		timer.one_shot = true
		timer.connect("timeout", self, "queue_free")
		add_child(timer)
		timer.start(duration)

	$InfectionZone/TextureShape.material.set_shader_param("infection_color", color)
	$InfectionZone.connect("body_entered", self, "infect")
	update_size()

func _physics_process(delta:float):
	if (duration > 0.0):
		size += growth * delta
		strength -= delta / duration
		update_size()

func infect(body:PhysicsBody2D):
	if (body != parent and body.is_class("Person")):
		body.emit_signal("infected", infectiousness)

func update_size():
	$InfectionZone/TextureShape.material.set_shader_param("strength", strength)
	$InfectionZone/TextureShape.scale = size * Vector2(1.0, 1.0 + height)
	$InfectionZone/TextureShape.position.y = -base_height * size
	$InfectionZone/CollisionShape2D.shape.height = base_height * height * size
	$InfectionZone/CollisionShape2D.shape.radius = base_radius * size
	$InfectionZone/CollisionShape2D.position.y = -0.5 * base_radius * size

