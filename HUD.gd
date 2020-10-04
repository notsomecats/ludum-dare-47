extends CanvasLayer

signal map_change(mode)

enum { IDLE, DEAD, WORKING, GAMING, MENU }

export var current_map = "Home"
export var previous_map = "Home"
export var time = 8
var hp
var time_suffix
var player
var last_message
var dead
var in_menu
var score


func _ready():
	restart()
	init()
	$Control.visible = false
	in_menu = true


func restart():
	$Control.visible = true
	$TimerHour.start()
	hp = 1000
	time_suffix = "AM"
	current_map = "Home"
	previous_map = "Home"
	time = 8
	last_message = ""
	dead = false
	in_menu = false
	score = 0
	init()


func start_scoring():
	$TimerScore.start()


func stop_scoring():
	$TimerScore.stop()


func init():
	$Control/ProgressBar.value = hp
	update_time()
	hide_label()
	init_label_interactive()
	fade_in()
	check_day_mode()
	for member in get_tree().get_nodes_in_group("interactable"):
		member.connect("show_label", self, "show_label")
		member.connect("hide_label", self, "hide_label")
	for member in get_tree().get_nodes_in_group("map"):
		member.connect("add_log", self, "add_log")


func _process(delta):
	if !in_menu:
		hp = hp - 0.3
		$Control/ProgressBar.value = hp
		check_life()


func fade_out():
	$TweenFade.stop_all()
	$TweenFade.interpolate_property($ColorRectFade, "color", Color(0.18, 0.2, 0.36, 0), Color(0.18, 0.2, 0.36, 1), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$TweenFade.start()


func fade_in():
	$TweenFade.stop_all()
	$TweenFade.interpolate_property($ColorRectFade, "color", Color(0.18, 0.2, 0.36, 1), Color(0.18, 0.2, 0.36, 0), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$TweenFade.start()


func init_label_interactive():
	$LabelInteractable.visible = false
	$TweenInteractable.interpolate_property($LabelInteractable, "rect_scale", Vector2(1,1), Vector2(1.1, 1.1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$TweenInteractable.interpolate_property($LabelInteractable, "rect_scale", Vector2(1.1,1.1), Vector2(1, 1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.5)
	$TweenInteractable.interpolate_property($LabelInteractable, "rect_rotation", 0, 5, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	$TweenInteractable.interpolate_property($LabelInteractable, "rect_rotation", 5, -5, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.5)
	$TweenInteractable.start()


func set_player(spawned_player):
	player = spawned_player


func update_time():
	if time < 12:
		time_suffix = "AM"
	else:
		time_suffix = "PM"
	$Control/Time.text = str(time) + ":00 " + time_suffix


func check_day_mode():
	if time > 6 and time < 17:
		emit_signal("map_change", "day")
	else:
		emit_signal("map_change", "night")


func _on_Timer_timeout():
	time = time + 1
	if time > 23:
		time = 0
	update_time()
	check_day_mode()


func hide_label():
	$LabelInteractable.hide()


func show_label(text, position):
	position = Vector2(position.x - 60, position.y)
	$LabelInteractable.show()
	$LabelInteractable.set_position(position)
	$LabelInteractable.text = text


func set_player_position():
	for member in get_tree().get_nodes_in_group("spawn"):
		print_debug(member.name)
		player.position = member.position


func add_log(message):
	if message != last_message:
		last_message = message
		$Control/Log.text = $Control/Log.text + "\n" + message
		return true
	return false


func check_life():
	if hp <= 0 and !dead:
		dead = true
		fade_out()
		$TimerDead.start()
		$Control.visible = false
		stop_scoring()


func _on_TimerDead_timeout():
	var root = get_tree().get_root()
	for member in get_tree().get_nodes_in_group("map"):
		root.remove_child(member)
		member.call_deferred("free")
	var next_level_resource = load("res://Death.tscn")
	var next_level = next_level_resource.instance()
	get_node("/root/Main/Map").add_child(next_level)
	fade_in()


func _on_TimerScore_timeout():
	score = score + 0.5

func add_hp(amount):
	hp = hp + amount
