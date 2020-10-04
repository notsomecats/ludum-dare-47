extends "Map.gd"

var lines = [
	"I'm so tired",
	"I wonder how that one dude I used to talk to is doing",
	"What am I going to have for dinner?",
	"Have I been gaining weight",
	"I should really start going to the gym",
	"Wish I could just sleep all day",
	"How are the neighbours this loud?"
]

var random


func _ready():
	random = RandomNumberGenerator.new()
	print_debug(hud.time)


func _on_TimerLog_timeout():
	if hud.time > 6 and hud.time < 10:
		if hud.add_log("I should go to work soon"):
			return
		
	if hud.time > 10 and hud.time < 12:
		if hud.add_log("I should really be at work"):
			hud.add_hp(-20)
			return
		
	if hud.time > 12 and hud.time < 17:
		if hud.add_log("I'm just not working today am I"):
			hud.add_hp(-30)
			return
	
	if hud.time > 23 or hud.time < 6:
		if hud.add_log("I'm pretty tired"):
			return
	
	var index = random.randi_range(0, lines.size() - 1)
	emit_signal("add_log", lines[index])
