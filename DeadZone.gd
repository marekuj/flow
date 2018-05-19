extends Node

func _ready():
	pass

func _on_Area2D_body_entered(body):
	body.emit_signal("hit")
