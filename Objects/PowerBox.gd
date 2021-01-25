extends Node2D

var broken : bool= false

func _ready():
	broken = false

func _process(delta):
	if $InteractArea.overlaps_body(GameManager.player) and Input.is_action_just_pressed("interact") and broken == false:
		broken = true
		get_tree().call_group("lights", "break", self.position)
