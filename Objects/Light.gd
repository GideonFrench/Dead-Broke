extends Node2D

var vol : float = -20
var difference : float = 0
var broken : bool = false

func _ready():
	$HumSound.volume_db = vol
	add_to_group("lights")
	broken = false

func _process(delta):
	
	vol = -position.distance_to(GameManager.player.position)
	difference = abs(vol - 0)
	vol += 300
	if vol > -15:
		vol = -15
	$HumSound.volume_db = vol
	
func break(pos):
	if (position.distance_to(pos) < 500):
		$HumSound.stop()
		if broken == false:
			broken = true
			$AnimationPlayer.play("Break")

func _on_BreakTimer_timeout():
	$AnimationPlayer.stop()
	$BreakSound.stop()

func _on_LightArea_area_entered(area):
	if area.name == "Hitbox" and broken == false:
		GameManager.player.hidden = false

func _on_LightArea_area_exited(area):
	if area.name == "Hitbox" and broken == false:
		GameManager.player.hidden = true
	
