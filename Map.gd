extends Node2D

signal add_log()

var root
var player
var hud

var words = ["bills", "old friends", "grandpa", "hummus", "pizza", "toast", "barbecue", "cats", "kittens", "puppies", "raccoons", "football", "broken mouse", "broken keyboard", "yesterday's report", "skin cancer", "urinals", "donuts", "marriage", "grammar", "spellcheck", "emails", "replies", "dentist", "toothpick", "cockroaches", "vegans", "steak", "pre-orders", "politics", "nuclear weapons", "plague", "memes", "manga", "anime", "weebs", "dementia", "that one thing", "I forgot", "I can't", "You can", "what", "when", "how", "who"]

func _ready():
	root = get_tree().get_root()
	var scene = load("res://Player.tscn")
	player = scene.instance()
	self.add_child(player)
	for member in get_tree().get_nodes_in_group("hud"):
		hud = member
		member.init()
		member.set_player_position()
		member.connect("map_change", self, "map_change")
		if member.time > 6 and member.time < 17:
			map_change("day")
		else:
			map_change("night")


func map_change(mode):
	$AnimatedSprite.animation = mode
