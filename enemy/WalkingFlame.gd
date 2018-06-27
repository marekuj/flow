extends KinematicBody2D

signal in_water

const MIN_SPEED = 150
const MAX_SPEED = 250
const FLOOR_NORMAL = Vector2(0, -1)
const GRAVITY_VEC = Vector2(0, 900)

var velocity = Vector2()
var delay = 0
var is_spreading = false # start spreading when enemy is in viewport

onready var timer_spread = $SpreadTimer
onready var timer_disappear = $DisappearTimer
onready var width =  $CollisionShapeMap.shape.extents.x
onready var flame = $Flame

var mob_obj = preload("res://enemy/WalkingFlame.tscn")
var smoke = preload("res://enemy/Smoke.tscn")
var smoke_instance

export var speed = 0
export var spread_counter = 3
export var fallable = false

func _ready():
	if speed == 0:
		speed = rand_range(MIN_SPEED, MAX_SPEED) * pow(-1, randi()%2)
	velocity.x = speed
	timer_spread.wait_time = rand_range(timer_spread.wait_time, timer_spread.wait_time*2)

func _process(delta):
	if !is_spreading && is_in_viewport():
		is_spreading = true
		timer_spread.start()
	
func _physics_process(delta):
	if delay > 0:
		delay -= delta
		return

	var gravity = delta * GRAVITY_VEC
	velocity += gravity

	velocity = move_and_slide(velocity, FLOOR_NORMAL, 0)
	
	if is_on_wall():
		speed = -speed
		velocity.x = speed
	
	if !fallable && !test_move(Transform2D(0, position+Vector2(width, 0)*velocity.normalized()), gravity):
		speed = -speed
		velocity.x = speed


func _on_Area2D_body_entered(body):
	body.emit_signal("hit")


func _on_SpreadTimer_timeout():
	if spread_counter <= 0:
		timer_spread.queue_free()
		return

	var new_mob = mob_obj.instance()
	new_mob.spread_counter = spread_counter - 1
	new_mob.position = position
	new_mob.delay = 1 + randf()

	if (new_mob.speed * speed > 0):
		new_mob.speed *= -1

	get_parent().add_child(new_mob)

func is_in_viewport():
	var ctrans = get_viewport().get_canvas_transform()
	var min_pos = -ctrans.get_origin() / ctrans.get_scale()

	return Rect2(min_pos, get_viewport().get_visible_rect().size).has_point(position)

func _on_Flame_in_water():
	if flame != null:
		set_physics_process(false)
		flame.emitting = false
		flame = null
		smoke_instance = smoke.instance()
		add_child(smoke_instance)
		timer_disappear.start()

func _on_DisappearTimer_timeout():
	smoke_instance.emitting = false

