extends Node2D

var level_limit : int = 10
var entry : bool = false

func _process(delta):
#	if entry == false:
#		entry = true
#		get_tree().call_group("fade", "fade_in")
	pass

func _on_EndArea_area_entered(area):
	if area.name == "Hitbox":
		$FadeOutTimer.start()
		GameManager.player.caught = true
		get_tree().call_group("fade", "fade_out_sharp")
		
		
func _on_FadeOutTimer_timeout():
	get_tree().call_group("alarms", "alarm_stop")
	if GameManager.id < level_limit:
			GameManager.id += 1
			GameManager.change_scene()
