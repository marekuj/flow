extends Node2D

signal dropped

onready var drop_timer = $DropTimer
onready var destroy_timer = $DestroyTimer

export var timeout = 2.0
export var time_to_live = 1.0
export var gravity_scale = 4.0

var destroy_queue = []
var drop = preload("res://enemy/Drop.tscn")

func _ready():
	drop_timer.wait_time = timeout
	destroy_timer.wait_time = time_to_live
	drop_timer.start()

func _on_DropTimer_timeout():
	var new_drop = drop.instance()
	new_drop.position = to_local(position)
	new_drop.gravity_scale = gravity_scale
	add_child(new_drop)
	destroy_queue.push_back(new_drop)


func _on_DestroyTimer_timeout():
	var drop = destroy_queue.pop_front()
	if drop != null:
		drop.queue_free()

func _on_DroppingFlame_dropped():
	destroy_timer.start()
	drop_timer.start()
