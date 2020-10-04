extends "Map.gd"

var lines = [
	"Is it really that hard to indicate?",
	"Man the traffic's extra bad today",
	"Oh man I love this song",
	"How long has it been since I started this job?",
]

var random
var teleporter


func _ready():
	print_debug(hud.previous_map)
	random = RandomNumberGenerator.new()
	for member in get_tree().get_nodes_in_group("teleporter"):
		teleporter = member
	player.set_status_busy()
	if hud.previous_map == "Office":
		$AnimatedSprite.flip_h = true
		$Car.flip_h = true
		player.flip()
		teleporter.destination = "Home"
	move_child(player, 2)


func _on_TimerLog_timeout():
	var index = random.randi_range(0, lines.size() - 1)
	emit_signal("add_log", lines[index])


func _on_TimerDrive_timeout():
	teleporter.teleport()


func map_change(mode):
	.map_change(mode)
	$Car.animation = mode
