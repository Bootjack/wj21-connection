class_name Player
extends KinematicBody2D

signal disinfected
signal infected

export var speed:float = 3.0
export var tilemap_paths = []
export var tilemap_heights = []

var height:float = 0.0
var infection = 0.0
var infection_rate = -1.0
var tilemaps = []
var vertical:float = 0.0

func _ready():
	connect("disinfected", self, "_on_disinfected")
	connect("infected", self, "_on_infected")
	for path in tilemap_paths:
		var node = get_node(path)
		tilemaps.append(node)

func _process(delta):
	if (Input.is_action_pressed("ui_left")):
		move(Vector2.LEFT)
	if (Input.is_action_pressed("ui_right")):
		move(Vector2.RIGHT)
	if (Input.is_action_pressed("ui_up")):
		move(12 * Vector2.LEFT + 48 * Vector2.UP)
	if (Input.is_action_pressed("ui_down")):
		move(12 * Vector2.RIGHT + 48 * Vector2.DOWN)
	if (Input.is_action_just_pressed("jump")):
		jump()

	fall(delta)
	infection = max(0.0, infection + infection_rate)
	$Label.text = "%.1f" % [infection]

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
	move_and_collide(direction.normalized() * speed)
