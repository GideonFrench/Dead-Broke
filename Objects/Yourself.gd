extends KinematicBody2D

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

func _ready():
	alerted = false
	isprite.visible = true
	dsprite.visible = false
	gisprite.visible = false
	sound_played = false

func _process(delta):
	if alive == false:
		dsprite.visible = true
		isprite.visible = false
		gisprite.visible = false
		$MainCollision.disabled = true
		get_tree().call_group("fade", "fade_out_complete")
		GameManager.player.caught = true
		if sound_played == false:
			$Siren.play()
			$DeathTimer.start()
			sound_played = true
			$ThumpTimer.start()
	
func _on_ThumpTimer_timeout():
	$AnimationPlayer.play("Thump")

func _on_DeathTimer_timeout():
	GameManager.id = 9
	GameManager.ender()
