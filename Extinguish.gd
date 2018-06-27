extends Area2D

onready var end = $"../../End"

func _on_Extinguish_body_entered(body):
	body.emit_signal("in_water")
	var timer = Timer.new()
	timer.process_mode = 0
	timer.one_shot = true
	timer.autostart = false
	timer.wait_time = 4
	timer.connect("timeout", self, "show_end")
	timer.start()
	add_child(timer)

func show_end():
	end.show() 