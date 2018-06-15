extends KinematicBody2D

signal hit
signal bullet

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
var gui_instance = null 
var global = null
var firstUpdate = true

var bullet = load("res://Bullet.tscn")
var gameManu = load("res://GameMenu.tscn")
var qui = load("res://Gui.tscn")

var bullet_number = null

onready var mouse_pos = get_viewport().get_mouse_position()
onready var animated_sprite = $AnimatedSprite
onready var respawn_timer = $RespawnTimer
onready var weapon = $AnimatedSprite2
onready var camera = $Camera2D


func _ready():
	global = get_node("/root/Global")

	animated_sprite.animation = "idle"
	animated_sprite.play()
	weapon.play()


func _input(event):
	if (event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed):
		if (bullet_number > 0):
			shoot()


func _physics_process(delta):
	prepare()	
	updateGui()

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
	global.lives-= 1
	gui_instance.setLives(global.lives)
	animated_sprite.animation = "dead"
	respawn_timer.start()


func _on_Player_bullet():
	if !alive:
		return

	bullet_number += 1
	gui_instance.setBullets(bullet_number)


func _on_RespawnTimer_timeout():
	if global.lives == 0:
		global.reset()
		get_tree().change_scene("res://Level.tscn")
	else:
		get_tree().reload_current_scene()


func shoot():
	var bullet_instance = bullet.instance()
	bullet_instance.position = weapon.get_global_position()
	bullet_instance.direction = mouse_pos
	bullet_instance.maker = self
	get_parent().add_child(bullet_instance)
	bullet_number -= 1
	gui_instance.setBullets(bullet_number)	


func prepare():	
	if !firstUpdate:
		return 

	gui_instance = qui.instance()
	get_parent().add_child(gui_instance)
	gui_instance.setLives(global.lives)
	gui_instance.setBullets(global.bullets)

	bullet_number = global.bullets

	firstUpdate = false	


func showMenu():	
	var gameManu_instance = gameManu.instance()
	get_parent().add_child(gameManu_instance)

	var center = camera.get_camera_screen_center() - gameManu_instance.rect_size/2
	gameManu_instance.margin_left = center.x
	gameManu_instance.margin_top = center.y


func updateGui():
	if Input.is_action_just_pressed("ui_cancel"):
		showMenu()
			
	var pos = camera.get_camera_screen_center() - get_viewport().get_visible_rect().size/2

	gui_instance.margin_left = pos.x
	gui_instance.margin_top = pos.y + 40
