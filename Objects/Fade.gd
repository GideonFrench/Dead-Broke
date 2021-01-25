extends Node2D

# Type of fade
var blur : bool = true

onready var bfsprite : Sprite = get_node("BlurFade")
onready var fsprite : Sprite = get_node("FadeSprite")

func _ready():
	bfsprite.visible = false
	fsprite.visible = false

func fade_out():
	if blur:
		bfsprite.visible = true
		fsprite.visible = false
		$AnimationPlayer.play("BlurFadeout")
	else:
		bfsprite.visible = false
		fsprite.visible = true
		$AnimationPlayer.play("Fadeout")

func fade_out_sharp():
	bfsprite.visible = false
	fsprite.visible = true
	$AnimationPlayer.play("Fadeout")

func fade_in_sharp():
	bfsprite.visible = false
	fsprite.visible = true
	$AnimationPlayer.play("Fadein")
	
func fade_out_complete():
	bfsprite.visible = true
	fsprite.visible = false
	$AnimationPlayer.play("FadeOutFull")
