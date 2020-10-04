extends "Map.gd"

var lines = [
	"Oh nice, there's dome donuts",
	"The water cooler's nearly empty again",
	"Man they have the A/C on way too high",
	"I should be getting paid more",
	"Is that light flickering or is it just me?",
	"Does he ever do anything other than Facebook?",
	"God I probably have another meeting soon",
	"What day was it today?",
]

var random


func _ready():
	random = RandomNumberGenerator.new()


func _on_TimerLog_timeout():
	var index = random.randi_range(0, lines.size() - 1)
	emit_signal("add_log", lines[index])
