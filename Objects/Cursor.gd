extends KinematicBody2D

onready var csprite : Sprite = get_node("CursorSprite")
var speed : int = 1000

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	self.position = get_global_mouse_position()
