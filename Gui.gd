extends Control

onready var Info = $InfoLabel

func _ready():
	pass


func setText(text):	
	Info.text = str(text)
