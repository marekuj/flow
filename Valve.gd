extends Sprite

var spin = false
var opened = false
var pouring = false
var water_initial_scale_y

onready var water = $"../Water"
onready var water_collision = $"../Water/WaterArea/Collision"
onready var player = $"../Player"

func _process(delta):
	if !opened && rotation_degrees >= 360:
		spin = false
		opened = true
		pour_water()
	
	if !opened && spin:
		rotate(3 * delta)
	
	if pouring:
		water.scale.y += delta
		if water.scale.y >= water_initial_scale_y:
			pouring = false
			

func pour_water():
	player.alive = false
	player.get_camera().zoom = Vector2(1.5, 1.5)
	player.get_camera().offset.x -= 400
	water_initial_scale_y = water.scale.y
	water.scale.y = 0.01
	water_collision.disabled = false
	water.show()
	pouring = true

func _on_Area2D_body_entered(body):
	spin = true


func _on_Area2D_body_exited(body):
	spin = false
