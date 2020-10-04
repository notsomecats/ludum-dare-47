extends "Interactable.gd"

var root
export var destination = "Drive"

func _ready():
	root = get_tree().get_root()


func _on_Teleporter_area_entered(area):
	in_range = true
	var label_position = Vector2(position.x, position.y - 110)
	emit_signal("show_label", "Move", label_position)


func _process(delta):
	if in_range and Input.is_action_pressed("ui_accept"):
		teleport()


func teleport():
	$TimerMove.start()
	hud.fade_out()
 

func move():
	hud.current_map = destination
	hud.previous_map = get_parent().name
	for member in get_tree().get_nodes_in_group("map"):
		root.remove_child(member)
		member.call_deferred("free")
	var next_level_resource = load("res://" + destination + ".tscn")
	var next_level = next_level_resource.instance()
	get_node("/root/Main/Map").add_child(next_level)


func _on_Teleporter_area_exited(area):
	in_range = false
	emit_signal("hide_label")


func _on_TimerMove_timeout():
	move()
