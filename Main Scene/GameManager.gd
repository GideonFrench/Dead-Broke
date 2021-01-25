extends Node

var player
var alarmed : bool = false
var end : bool = false
var id : int = 1
onready var current_scene = get_tree().get_root().get_node("Scene"+str(GameManager.id))
	
func _process(delta):
	if Input.is_action_just_pressed("reload_scene"):
		get_tree().call_group("alarms", "alarm_stop")
		ender()

func ender():
	get_tree().change_scene("res://Main Scene/Scene"+str(GameManager.id)+".tscn")
	
func change_scene():
	get_tree().change_scene("res://Main Scene/Scene"+str(GameManager.id)+".tscn")
