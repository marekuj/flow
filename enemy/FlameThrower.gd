extends Node2D

const STEP = deg2rad(10)

onready var flame = $Flame
onready var flame2 = $Flame2

export var radius = 150.0
export var velocity = 150.0

var drop_obj = preload("res://enemy/Drop.tscn")
var aim = Vector2(0, 1)

func _ready():
	pass

func _on_RotationTimer_timeout():
	aim = aim.rotated(STEP)

func _on_ThrowTimer_timeout():
	var drop = drop_obj.instance()
	drop.linear_velocity = aim * velocity
	drop.gravity_scale = 0
	drop.max_distance = radius
	drop.set_collision_mask_bit(0, false)
	add_child(drop)
