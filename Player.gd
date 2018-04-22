extends KinematicBody2D

const GRAVITY_VEC = Vector2(0, 900)
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 25.0
const MIN_ONAIR_TIME = 0.1
const WALK_SPEED = 250 # pixels/sec
const JUMP_SPEED = 480
const SIDING_CHANGE_SPEED = 10

var velocity = Vector2()
var onair_time = 0
var on_floor = false

onready var sprite = $AnimatedSprite

func _physics_process(delta):

	onair_time += delta

	# Apply Gravity
	velocity += delta * GRAVITY_VEC
	
	# Move
	velocity = move_and_slide(velocity, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	
	# Detect Floor
	if is_on_floor():
		onair_time = 0

	on_floor = onair_time < MIN_ONAIR_TIME

	# Horizontal Movement
	var target_speed = 0
	if Input.is_action_pressed("ui_left"):
		target_speed += -1
	if Input.is_action_pressed("ui_right"):
		target_speed +=  1

	target_speed *= WALK_SPEED
	velocity.x = lerp(velocity.x, target_speed, 0.1)

	# Jump
	if on_floor and Input.is_action_just_pressed("ui_up"):
		velocity.y = -JUMP_SPEED
