extends KinematicBody2D

signal hit

const MAX_BULLETS = 3
const GRAVITY_VEC = Vector2(0, 900)
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 25.0
const MIN_ONAIR_TIME = 0.1
const WALK_SPEED = 250 # pixels/sec
const JUMP_SPEED = 500
const SIDING_CHANGE_SPEED = 10

var velocity = Vector2()
var onair_time = 0
var on_floor = false
var alive = true

var bullet = load("res://Bullet.tscn")

var bullet_number = MAX_BULLETS

onready var mouse_pos = get_viewport().get_mouse_position()
onready var animated_sprite = $AnimatedSprite
onready var respawn_timer = $RespawnTimer
onready var weapon = $AnimatedSprite2
onready var camera = $Camera2D

func _ready():
	animated_sprite.animation = "idle"
	animated_sprite.play()
	weapon.play()

func _input(event):
	if (event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed):
		if (bullet_number > 0):
			shoot()
		
func _physics_process(delta):
	mouse_pos = camera.get_global_mouse_position()
	weapon.look_at(mouse_pos)
	
	if !alive:
		return

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
	

	if velocity.x != 0 && on_floor:
		var is_accelerating = (Input.is_action_pressed("ui_left") || Input.is_action_pressed("ui_right"))
		if is_accelerating:
			animated_sprite.animation = "move"
		else:
			animated_sprite.animation = "slide"
		animated_sprite.flip_h = velocity.x < 0
	elif !on_floor:
		if velocity.y < 0:
			animated_sprite.animation = "ascend"
		else:
			animated_sprite.animation = "descend"
		animated_sprite.flip_h = velocity.x < 0
	else:
		animated_sprite.animation = "idle"


func _on_Player_hit():
	if !alive:
		return

	alive = false
	animated_sprite.animation = "dead"
	respawn_timer.start()

func _on_RespawnTimer_timeout():
	get_tree().reload_current_scene()
	
func shoot():
	var bullet_instance = bullet.instance()
	bullet_instance.position = weapon.get_global_position()
	bullet_instance.direction = mouse_pos
	get_parent().add_child(bullet_instance)
	bullet_number -= 1
