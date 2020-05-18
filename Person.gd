class_name Person
extends KinematicBody2D

signal infected

var friction:float
var height:float = 0.0
var immunity_duration:float
var immunity_timer:Timer
var infection:float = 0.0
var infection_rate:float
var is_airborne:bool = false
var is_idle:bool = false
var is_immune:bool = false
var is_jumping:bool = false
var is_sprinting:bool = false
var sprint_factor:float
var sprint_timer:Timer
var tilemaps = []
var tilemap_heights = []
var tolerance = 10.0
var top_speed:float
var velocity:Vector2
var vertical:float

func _init():
	friction = 0.3
	immunity_duration = 1.0
	infection_rate = 0.0
	sprint_factor = 2.0
	top_speed = 4.0

func _ready():
	immunity_timer = Timer.new()
	immunity_timer.one_shot = true
	immunity_timer.connect("timeout", self, "_on_immunity_timeout")
	add_child(immunity_timer)
	
	sprint_timer = Timer.new()
	sprint_timer.one_shot = true
	sprint_timer.connect("timeout", self, "_on_sprint_timeout")
	add_child(sprint_timer)

	$Visualization/Sprite.connect("animation_finished", self, "idle")
	$Visualization/Sprite.play("Idle")
	
	connect("infected", self, "_on_infected")

func _process(delta):
	infection = max(0.0, infection + infection_rate)
	handle_movement()

func _physics_process(delta):
	fall(delta)
	slide(delta)

func _on_immunity_timeout():
	is_immune = false
	unhurt()

func _on_infected(infectiousness:float):
	if (!is_immune):
		infection += 10 * infectiousness
		is_immune = true
		immunity_timer.start(immunity_duration)
		hurt()

func _on_sprint_timeout():
	is_sprinting = false

func fall(delta):
	var tile_floor_height = floor_height()
	height = max(height + vertical * delta, tile_floor_height)
	$Visualization/Sprite.transform.origin.y = -24 * height
	$Visualization/Shadow.transform.origin.y = 48 - 24 * tile_floor_height
	vertical -= 9.8 * delta
	if (height >= tilemap_heights[2]):
		layers = 4
	elif (height >= tilemap_heights[1]):
		layers = 2
	else:
		layers = 1

	if (!is_immune and is_airborne and on_ground()):
		is_airborne = false
		is_jumping = false
		$Visualization/Sprite.connect("animation_finished", self, "idle")
		idle()

	if (!on_ground()):
		is_airborne = true

func floor_height():
	var tile
	var tile_position
	var highest = 0.0
	var tile_count = tilemaps.size()
	var i = 0
	
	for tilemap in tilemaps:
		tile_position = tilemap.world_to_map(global_position)
		tile = tilemap.get_cellv(tile_position)
		if (tile >= 0):
			highest = max(highest, tilemap_heights[i])
		i += 1
	
	return highest

func get_class():
	return "Person"

func handle_movement():
	is_idle = true
	yield()
	if (is_idle and !is_jumping and !is_immune):
		idle()

func hurt():
	pass

func idle():
	$Visualization/Sprite.play("Idle")

func is_class(name:String):
	return name == "Person" or .is_class(name)

func on_ground():
	var tile_floor_height = floor_height()
	return height <= tile_floor_height

func jump():
	is_jumping = true
	$Visualization/Sprite.disconnect("animation_finished", self, "idle")
	$Visualization/Sprite.play("Jump")
	if (on_ground()):
		vertical = 5.0

func move(direction:Vector2):
	is_idle = false
	velocity += direction * top_speed
	var speed = min(velocity.length(), top_speed)
	if (is_sprinting):
		speed *= 2.0

	if (direction.x > 0):
		$Visualization.scale.x = 1
	elif (direction.x < 0):
		$Visualization.scale.x = -1

	if (!is_immune and !is_jumping):
		if (is_sprinting):
			$Visualization/Sprite.play("Run")
		else:
			$Visualization/Sprite.play("Walk")

	velocity = velocity.normalized() * speed

func slide(delta):
	velocity *= 1.0 - friction
	move_and_slide(velocity * 100.0)

func sprint():
	if (!is_sprinting and on_ground()):
		is_sprinting = true
		sprint_timer.start(0.5)

func unhurt():
	pass
