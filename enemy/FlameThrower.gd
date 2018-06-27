extends Node2D

signal dropped

const STEP = deg2rad(10)

export var radius = 150.0
export var velocity = 150.0

var drop_obj = preload("res://enemy/Drop.tscn")
var aim = Vector2(0, 1)
var is_throwing = false

onready var timer_rotation = $RotationTimer
onready var timer_thrower = $ThrowTimer

func _on_RotationTimer_timeout():
	aim = aim.rotated(STEP)

func _on_ThrowTimer_timeout():
	var drop = drop_obj.instance()
	drop.linear_velocity = aim * velocity
	drop.gravity_scale = 0
	drop.max_distance = radius
	drop.set_collision_mask_bit(0, false)
	add_child(drop)

func _process(delta):
	if !is_throwing && is_in_viewport():
		is_throwing = true
		timer_rotation.start()
		timer_thrower.start()
	elif is_throwing && !is_in_viewport():
		is_throwing = false
		timer_rotation.stop()
		timer_thrower.stop()

func is_in_viewport():
	var ctrans = get_viewport().get_canvas_transform()
	var min_pos = -ctrans.get_origin() / ctrans.get_scale()

	return Rect2(min_pos, get_viewport().get_visible_rect().size * 1.2).has_point(position)