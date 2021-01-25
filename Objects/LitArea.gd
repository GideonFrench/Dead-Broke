extends Node2D

func _ready():
	pass

func _on_LightSquare_area_entered(area):
	if area.name == "Hitbox":
		GameManager.player.hidden = false

func _on_LightSquare_area_exited(area):
	if area.name == "Hitbox":
		GameManager.player.hidden = true
