extends "Map.gd"

var lines = [
	"Oh nice, they brought in donuts",
	"The water cooler's nearly empty again",
	"Man they have the A/C on way too high",
	"I should be getting paid more",
	"Is that light flickering or is it just me?",
	"Does he ever do anything other than Facebook?",
	"God I probably have another meeting soon",
	"What day was it today?",
	"No, please, chew your gum louder",
	"Am I wearing the same shirt as yesterday?",
	"What was her name again? Emma? Emily?",
	"Where did I put my notepad?",
	"I guess I'll have to use red pen again",
	"Wish they opened the blinds more",
	"Are they talking about golf again?",
]
var random


func _ready():
	random = RandomNumberGenerator.new()
	random.randomize()


func _on_TimerLog_timeout():
	if hud.time < 5 or hud.time > 19:
		hud.add_log("What the heck am I still doing here?")
		hud.add_hp(-20)
	var chance_words = random.randi_range(0, 5)
	if chance_words == 5:
		var first_word_index = random.randi_range(0, words.size() - 1)
		var second_word_index = random.randi_range(0, words.size() - 1)
		var first_word = words[first_word_index]
		var second_word = words[second_word_index]
		hud.add_log(first_word + " ... " + first_word + " ... " + second_word + " ... ")
	else:
		var index = random.randi_range(0, lines.size() - 1)
		hud.add_log(lines[index])
