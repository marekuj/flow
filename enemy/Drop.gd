extends RigidBody2D

var start_position
var max_distance = null

func _ready():
	start_position = position

func _physics_process(delta):
	if max_distance != null && (position - start_position).length_squared() > max_distance*max_distance:
		queue_free()

func _on_Area2D_body_entered(body):
	body.emit_signal("hit")
	get_parent().emit_signal("dropped")
