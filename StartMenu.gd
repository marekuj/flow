extends Control

var global = null

func _ready():
	global = get_node("/root/Global")

func _on_StartButton_pressed():
	global.reset()
	get_tree().change_scene("res://Level.tscn")	

func _on_ExitButton_pressed():
	get_tree().quit()
