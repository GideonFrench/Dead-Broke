extends KinematicBody2D

class_name Soldier

var alive : bool = true
var sound_played : bool = false
var sound : bool = false
var alerted : bool = false

#	--------------------
#	SPRITES
#	--------------------
onready var isprite : Sprite = get_node("Idle")
onready var dsprite : Sprite = get_node("Dead")
onready var gisprite : Sprite = get_node("GunIdle")
onready var vcsprite = get_node("DetectionArea")

func _ready():
	alerted = false
	isprite.visible = true
	dsprite.visible = false
	vcsprite.visible = true
	gisprite.visible = false
	sound_played = false

func _process(delta):
	if alive == true and alerted == false:
		$ViewAnimation.play("Viewing")
	if alive == true and $DetectionArea.overlaps_area(GameManager.player.get_node("Hitbox")) and GameManager.player.hidden == false:
		get_tree().call_group("alarms", "alarm_sound")
		get_tree().call_group("soldiers", "pointplayer")
		get_tree().call_group("player", "got_caught")
		get_tree().call_group("fade", "fade_out")
	if alive == false:
		dsprite.visible = true
		isprite.visible = false
		vcsprite.visible = false
		gisprite.visible = false
		$MainCollision.disabled = true
		
		if sound_played == false:
			sound_played = true
			$ThumpTimer.start()
	if alerted == true and alive == true:
		gisprite.visible = true
		gisprite.look_at(GameManager.player.position)
		isprite.look_at(GameManager.player.position)
		vcsprite.look_at(GameManager.player.position)
	
func _on_ThumpTimer_timeout():
	$AnimationPlayer.play("Thump")
	
func pointplayer():
	alerted = true
