extends KinematicBody2D

const BULLET_SPEED = 500
const LIFETIME = 250

var time_elapsed = 0
var direction

var velocity
var maker 

onready var sprite = $AnimatedSprite
onready var collisionBody = $CollisionShape2D

func _ready():
	sprite.animation = "flight"
	sprite.play()
	pass

func _physics_process(delta):
	lifecycle()
	velocity = (direction - position).normalized() * BULLET_SPEED
	if (direction - position).length() > 5:
		move_and_slide(velocity)
	else:
		sprite.animation = "default"
		collisionBody.disabled = false
	
func lifecycle():
	time_elapsed += 1
	if time_elapsed >= LIFETIME:
		maker.emit_signal("bullet")
		queue_free()
