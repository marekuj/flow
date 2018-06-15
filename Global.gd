extends Node

const MAX_LIEVES = 3
const MAX_BULLETS = 3

var lives = MAX_LIEVES
var bullets = MAX_BULLETS

func _ready():
	pass
	
func reset():
	lives = MAX_LIEVES
	bullets = MAX_BULLETS
