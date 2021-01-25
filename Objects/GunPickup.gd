extends Node2D

func _ready():
	$GunSprite.visible = true

func _on_PickupArea_body_entered(body):
	if body.name == "Player":
		body.has_pistol = true
		body.shots = 1
		$AnimationPlayer.play("Pickup")
