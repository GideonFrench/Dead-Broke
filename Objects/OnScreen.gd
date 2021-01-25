extends Node2D

var vis : bool = false

func _ready():
	self.visible = false
	vis = true

func _process(delta):
	pass


func _on_InteractArea_area_entered(area):
	if area.name == "Hitbox":
		$AnimationPlayer.play("FadeIn")

func _on_InteractArea_area_exited(area):
	if area.name == "Hitbox":
		$AnimationPlayer.play("FadeOut")
