extends Control

var global = null

func _ready():
	global = get_node("/root/Global")
	get_tree().paused = true


func _on_ComtinueButton_pressed():
	get_tree().paused = false
	hide()
	queue_free()


func _on_NewGameButton_pressed():
	global.reset()
	get_tree().paused = false
	get_tree().change_scene("res://Level.tscn")


func _on_ExitButton_pressed():
	get_tree().paused = false
	get_tree().quit()