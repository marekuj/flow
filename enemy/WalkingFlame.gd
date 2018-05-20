extends KinematicBody2D

const MIN_SPEED = 150
const MAX_SPEED = 250
const FLOOR_NORMAL = Vector2(0, -1)
const GRAVITY_VEC = Vector2(0, 900)

var speed = rand_range(MIN_SPEED, MAX_SPEED) * pow(-1, randi()%2)
var velocity = Vector2()
var delay = 0

onready var timer = $SpreadTimer
onready var width = $CollisionShapeMap.shape.extents.x

var mob_obj = preload("res://enemy/WalkingFlame.tscn")

func _ready():
	velocity.x = speed
	timer.wait_time = rand_range(timer.wait_time, timer.wait_time*2)
	
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

	if !test_move(Transform2D(0, position+Vector2(width, 0)*velocity.normalized()), gravity):
		speed = -speed
		velocity.x = speed
		

func _on_Area2D_body_entered(body):
	body.emit_signal("hit")


func _on_SpreadTimer_timeout():
	var new_mob = mob_obj.instance()
	new_mob.position = position
	new_mob.delay = 1 + randf()

	if (new_mob.speed * speed > 0):
		new_mob.speed *= -1

	get_parent().add_child(new_mob)
