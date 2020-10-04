extends Node2D

var messages = [
	"You tried your best, didn't you.",
	"I'm sure you made the most of your time.",
	"Look, you lived such a fulfilling life.",
	"Surely everyone will remember you.",
	"You were content enough, weren't you?",
	"Really made a mark in the world.",
]
var continue_enabled = false
var continuing = false
var hud
var random


func _ready():
	random = RandomNumberGenerator.new()
	random.randomize()
	$Player.die()
	for member in get_tree().get_nodes_in_group("hud"):
		hud = member
	var message = messages[random.randi_range(0, messages.size() - 1)]
	$Canvas/LabelScore.text = "Your score is: " + str(hud.score)
	$Canvas/LabelMessage.text = message


func _process(delta):
	if continue_enabled and !continuing and Input.is_action_pressed("ui_accept"):
		continuing = true
		hud.fade_out()
		$TimerContinue.start()


func _on_TimerCooldown_timeout():
	continue_enabled = true


func _on_TimerContinue_timeout():
	var root = get_tree().get_root()
	for member in get_tree().get_nodes_in_group("map"):
		root.remove_child(member)
		member.call_deferred("free")
	var next_level_resource = load("res://Menu.tscn")
	var next_level = next_level_resource.instance()
	get_node("/root/Main/Map").add_child(next_level)
	hud.fade_in()
