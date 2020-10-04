extends Node2D

var start_enabled = false
var starting = false
var hud
var score = 0

func _ready():
	for member in get_tree().get_nodes_in_group("hud"):
		hud = member


func _process(delta):
	if start_enabled and !starting and Input.is_action_pressed("ui_accept"):
		hud.start_scoring()
		starting = true
		hud.fade_out()
		$TimerStart.start()
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()


func _on_TimerCooldown_timeout():
	start_enabled = true


func _on_TimerStart_timeout():
	var root = get_tree().get_root()
	for member in get_tree().get_nodes_in_group("map"):
		root.remove_child(member)
		member.call_deferred("free")
	var next_level_resource = load("res://Home.tscn")
	var next_level = next_level_resource.instance()
	get_node("/root/Main/Map").add_child(next_level)
	hud.fade_in()
	hud.restart()


func _on_TimerGame_timeout():
	score = score + 0.5
	print_debug(score)
