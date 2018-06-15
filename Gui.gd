extends Control

onready var InfoHeart = $InfoHeart
onready var InfoBullets = $InfoBullets

func _ready():
	pass


func setLives(text):
	InfoHeart.text = str(text)

func setBullets(text):
	InfoBullets.text = str(text)
