class_name Player
extends KinematicBody2D

signal disinfected
signal infected

export var top_speed:float = 6.0
export var tilemap_paths = []
export var tilemap_heights = []

var height:float = 0.0
var infection:float = 0.0
var infection_rate:float = -0.5
var is_sprinting:bool = false
var sprint_timer:Timer
var tilemaps = []
var velocity:Vector2
var vertical:float

func _ready():
	sprint_timer = Timer.new()
	sprint_timer.one_shot = true
	sprint_timer.connect("timeout", self, "sprint_timeout")
	add_child(sprint_timer)
	
	connect("disinfected", self, "_on_disinfected")
	connect("infected", self, "_on_infected")
	
	for path in tilemap_paths:
		var node = get_node(path)
		tilemaps.append(node)

func _process(delta):
	if (Input.is_action_pressed("left")):
		move(Vector2(-1.0, 0.0))
	if (Input.is_action_pressed("right")):
		move(Vector2(1.0, 0.0))
	if (Input.is_action_pressed("up")):
		move(Vector2(-0.2, -0.8))
	if (Input.is_action_pressed("down")):
		move(Vector2(0.2, 0.8))
	if (Input.is_action_just_pressed("jump")):
		jump()
	if (Input.is_action_just_pressed("sprint")):
		sprint()
	infection = max(0.0, infection + infection_rate)

func _physics_process(delta):
	fall(delta)
	slide(delta)

func _on_disinfected(infectiousness:float):
	infection_rate -= infectiousness

func _on_infected(infectiousness:float):
	infection_rate += infectiousness

func fall(delta):
	var tile_floor_height = floor_height()
	height = max(height + vertical * delta, tile_floor_height)
	$Sprite.transform.origin.y = -26 * height
	$Shadow.transform.origin.y = 26 - 26 * tile_floor_height
	vertical -= 9.8 * delta
	if (height >= tilemap_heights[1]):
		collision_layer = 2
		collision_mask = 2
	else:
		collision_layer = 1
		collision_mask = 1

func floor_height():
	var tile
	var tile_height
	var tile_position
	var tilemap_idx = 0
	var highest = 0.0
	
	for tilemap in tilemaps:
		tile_position = tilemap.world_to_map(global_position)
		tile = tilemap.get_cellv(tile_position)
		if (tile >= 0):
			highest = max(highest, tilemap_heights[tilemap_idx])
		tilemap_idx += 1
	
	return highest

func friction():
	if (on_ground()):
		return 0.2
	else:
		return 0.2

func get_class():
	return "Player"
	
func is_class(name:String):
	return name == "Player" or .is_class(name)

func on_ground():
	var tile_floor_height = floor_height()
	return height <= tile_floor_height

func jump():
	if (on_ground()):
		vertical = 5.0

func move(direction:Vector2):
	velocity += direction
	var speed = min(velocity.length(), top_speed)
	if (is_sprinting):
		speed *= 2.0
	velocity = velocity.normalized() * speed

func slide(delta):
	velocity *= 1.0 - friction()
	move_and_collide(velocity)

func sprint():
	if (!is_sprinting and on_ground()):
		is_sprinting = true
		sprint_timer.start(0.5)

func sprint_timeout():
	is_sprinting = false
