extends KinematicBody2D

var direction : Vector2 = Vector2()
var speed = 2000
var vel : Vector2 = Vector2()
var thrown : bool = false

func _ready():
	thrown = false

func _process(delta):
	speed -= 150
	
	if thrown == false:
		vel = position.direction_to(get_global_mouse_position()) * speed
		thrown = true
		$ThrowTimer.start()
		$AnimationPlayer.play("Thrown")
	
	vel = move_and_slide(vel, Vector2(0, 0))

func _on_ThrowTimer_timeout():
	vel = Vector2(0, 0)
	$AnimationPlayer.stop()

func _on_KillArea_body_entered(body):
	if body.is_in_group("soldiers"):
		body.alive = false
