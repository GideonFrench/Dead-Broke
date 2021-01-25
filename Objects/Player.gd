extends KinematicBody2D

# Assets
# Cursor from https://kicked-in-teeth.itch.io/point
# Tiles from https://vectorpixelstar.itch.io/1-bit-patterns-and-tiles
# Font from https://datagoblin.itch.io/monogram

#	--------------------
#	SPEED AND ACCELERATION CONSTANTS
#	--------------------
var base_speed : int = 500
var max_speed : int = 550
var acceleration : float = 1.5
var cutoff : int =  120
var friction : int = 60

#	--------------------
#	MOUSE POSITION AND DIRECTION
#	--------------------
var mousepos : Vector2 = get_global_mouse_position()
var mousedirection : Vector2 = position.direction_to(get_global_mouse_position())

#	--------------------
#	DIRECTIONS
#	--------------------
var udirection : Vector2 = Vector2()
var ddirection : Vector2 = Vector2()
var ldirection : Vector2 = Vector2()
var rdirection : Vector2 = Vector2()
var direction : Vector2 = Vector2(position.x + 10, position.y)

#	--------------------
#	DIRECTIONAL SPEED
#	--------------------
var uspeed : int = 0
var dspeed : int = 0
var rspeed : int = 0
var lspeed : int = 0

#	--------------------
#	DIRECTIONAL VELOCITIES
#	--------------------
var uvel : Vector2 = Vector2()
var dvel : Vector2 = Vector2()
var lvel : Vector2 = Vector2()
var rvel : Vector2 = Vector2()
var vel : Vector2 = Vector2()

#	--------------------
#	SPRITES
#	--------------------
onready var isprite : Sprite = get_node("Idle")
onready var wsprite : Sprite = get_node("Walking")
onready var gisprite : Sprite = get_node("GunIdle")
onready var fsprite : Sprite = get_node("Flash")

onready var mainscene = get_tree().get_root().get_node("Main Scene")
onready var current_scene = get_tree().get_root().get_node("res://Main Scene/Scene"+str(GameManager.id)+".tscn")
onready var throwngun = preload("res://Objects/ThrownGun.tscn")

var footsteps = false

#	--------------------
#	GUN VARIABLES
#	--------------------
onready var laserpointer : Node2D = get_node("Pointer")
onready var laser : RayCast2D = $Pointer/Laser
onready var laser_cheat : Sprite = $Pointer/LaserSprite

var target : Vector2 = Vector2()
var shot_range : int = 2000
var shots : int = 0
var has_pistol : bool = false
var laser_pointer : bool = false
var hidden : bool = true
var caught : bool = false

#	--------------------
#	EXECUTED AT START
#	--------------------
func _ready():
	isprite.visible = true
	wsprite.visible = false
	gisprite.visible = false
	fsprite.visible = false
	laser_cheat.visible = false
	caught = false
	target = direction * shot_range
	direction = position.direction_to(Vector2(position.x, position.y + 10))
	GameManager.player = self

#	--------------------
#	EXECUTED EVERY FRAME
#	--------------------
func _process(delta):
#	--------------------
#	SETTING DIRECTIONS
#	--------------------
	var mousepos : Vector2 = get_global_mouse_position()
	var mousedirection : Vector2 = position.direction_to(mousepos)
	direction = position.direction_to(Vector2(position.x, position.y + 100000))
	udirection = direction.rotated(PI)
	ddirection = direction
	ldirection = direction.rotated(PI/2)
	rdirection = direction.rotated(-PI/2)

#	--------------------
#	LASER POINTER
#	--------------------
#	current_scene = get_tree().get_root().get_node("res://Main Scene/Scene"+str(GameManager.id)+".tscn")
	laserpointer.rotation = mousedirection.angle()

#	--------------------
#	ROTATING SPRITES
#	--------------------
	if caught == false:
		isprite.look_at(mousepos)
		wsprite.look_at(mousepos)
		gisprite.look_at(mousepos)
		fsprite.look_at(mousepos)
		
#	--------------------
#	IDLE ANIMATION
#	--------------------	
	if Input.is_action_pressed("move_up") == false and \
	Input.is_action_pressed("move_down") == false and \
	Input.is_action_pressed("move_left") == false and \
	Input.is_action_pressed("move_right") == false:
		$FootstepSound.stop()
		footsteps = false
		isprite.visible = true
		wsprite.visible = false
	
#	--------------------
#	WALK ANIMATION AND DIRECTIONAL SPEED/ACCLERATION
#	--------------------
	if Input.is_action_pressed("move_up") and caught == false:
		isprite.visible = false
		wsprite.visible = true
		$AnimationPlayer.play("Walk")
		if footsteps == false:
			footsteps = true
			$StepTimer.start()
			$FootstepSound.play()
		if uspeed < cutoff:
			uspeed = base_speed
		elif uspeed < max_speed:
			uspeed *= acceleration
	if Input.is_action_pressed("move_down") and caught == false:
		isprite.visible = false
		wsprite.visible = true
		$AnimationPlayer.play("Walk")
		if footsteps == false:
			footsteps = true
			$StepTimer.start()
			$FootstepSound.play()
		if dspeed < cutoff:
			dspeed = base_speed
		elif dspeed < max_speed:
			dspeed *= acceleration
	if Input.is_action_pressed("move_left") and caught == false:
		isprite.visible = false
		wsprite.visible = true
		$AnimationPlayer.play("Walk")
		if footsteps == false:
			footsteps = true
			$StepTimer.start()
			$FootstepSound.play()
		if lspeed < cutoff:
			lspeed = base_speed
		elif lspeed < max_speed:
			lspeed *= acceleration
	if Input.is_action_pressed("move_right") and caught == false:
		isprite.visible = false
		wsprite.visible = true
		$AnimationPlayer.play("Walk")
		if footsteps == false:
			footsteps = true
			$StepTimer.start()
			$FootstepSound.play()
		if rspeed < cutoff:
			rspeed = base_speed
		elif rspeed < max_speed:
			rspeed *= acceleration
	
#	--------------------
#	DIRECTIONAL FRICTION AND ANTI-SLIDE
#	--------------------
	if uspeed > cutoff:
		uspeed -= friction
	else:
		uspeed = 0
	if dspeed > cutoff:
		dspeed -= friction
	else:
		dspeed = 0
	if lspeed > cutoff:
		lspeed -= friction
	else:
		lspeed = 0
	if rspeed > cutoff:
		rspeed -= friction
	else:
		rspeed = 0
	
#	--------------------
#	DIRECTIONAL VELOCITY
#	--------------------
	uvel = uspeed * udirection
	dvel = dspeed * ddirection
	lvel = lspeed * ldirection
	rvel = rspeed * rdirection
	
#	--------------------
#	FINAL VELOCITY AND MOVEMENT
#	--------------------
	vel = uvel + dvel + lvel + rvel	
	vel = move_and_slide(vel, Vector2(0, 0))
	
	if has_pistol == true:
		gisprite.visible = true
		if laser_pointer == true:
			laser_cheat.visible = true
	else:
		gisprite.visible = false
	
	if Input.is_action_just_pressed("shoot") and shots > 0 and has_pistol == true:
		shots -= 1
		$GunAnimation.play("Fire")
		$GunSound.play()
		$GunTimer.start()
		laser.force_raycast_update()
		if laser.is_colliding() == true:
			var collided : Node = laser.get_collider()
			if collided.is_in_group("soldiers"):
				if collided.alive == true:
					collided.alive = false
	elif Input.is_action_just_pressed("shoot") and shots == 0 and has_pistol == true:
		$ClickSound.play()
		$ClickTimer.start()

	if Input.is_action_just_pressed("throw")  and has_pistol == true:
		has_pistol = false
		gisprite.visible = false
		shots = 0
		var thrown = throwngun.instance()
		thrown.set_position(self.position)
		current_scene = get_tree().get_root().get_node("Scene"+str(GameManager.id))
		current_scene = get_tree().get_root().get_node("Scene1")
		current_scene.get_node("SceneObjects").get_node("ThrownGuns").add_child(thrown)
		
func got_caught():
	fsprite.visible = false
	has_pistol = false
	shots = 0
	if caught == false:
		caught = true
		$EndSound.play()
		$EndTimer.start()
		$GunAnimation.play("GameOver")

func _on_GunTimer_timeout():
	$GunSound.stop()

func _on_StepTimer_timeout():
	$FootstepSound.stop()
	footsteps = false

func _on_ClickTimer_timeout():
	$ClickSound.stop()

func _on_EndTimer_timeout():
	$EndSound.stop()
	GameManager.ender()
