extends KinematicBody2D

enum { IDLE, DEAD, BUSY }
var velocity
export var status = IDLE
var speed = 200
var is_in_range_interactable = false
export var flipped = false


func _ready():
	for member in get_tree().get_nodes_in_group("hud"):
		member.set_player(self)
	for member in get_tree().get_nodes_in_group("interactable"):
		member.set_player(self)


func get_input():
	# Move
	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		flipped = velocity.x < 0
		$AnimatedSprite.flip_h = flipped
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		flipped = velocity.x < 0
		$AnimatedSprite.flip_h = flipped


func _physics_process(delta):
	if status != BUSY and status != DEAD:
		get_input()
		if velocity == Vector2.ZERO:
			$AnimatedSprite.animation = "idle"
		else:
			$AnimatedSprite.animation = "walk"
		velocity = velocity.normalized() * speed
		velocity = move_and_slide(velocity)


func set_status_busy():
	status = BUSY
	
	
func set_status_idle():
	status = IDLE


func flip():
	$AnimatedSprite.flip_h = true


func die():
	status = DEAD
	$AnimatedSprite.animation = "dead"
