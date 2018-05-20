extends Node2D

export var scene = ""

func _on_Area2D_body_entered(body):
	print(body)
	get_tree().change_scene(scene)
