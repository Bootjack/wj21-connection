class_name TrackingCamera
extends Camera2D

var target

func _ready():
	global_position.x = target.global_position.x + 200
	global_position.y = target.global_position.y

func _process(delta):
	var target_local = to_local(target.global_position)
	if (target_local.x > 200):
		global_position.x -= 200 - target_local.x
	if (target_local.x < -200):
		global_position.x += 200 + target_local.x
	if (target_local.y > 200):
		global_position.y -= 200 - target_local.y
	if (target_local.y < -200):
		global_position.y += 200 + target_local.y

func get_class():
	return "TrackingCamera"
	
func is_class(name:String):
	return name == "TrackingCamera" or .is_class(name)
