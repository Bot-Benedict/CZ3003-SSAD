extends KinematicBody2D

export (int) var SPEED = 100
onready var Map = $TileMap

var velocity = Vector2()
var screen_size

func _ready():
	set_physics_process(false)
	$AnimatedSprite.play(userModel.getUserAvatar())
	screen_size = get_viewport().size
	
func _physics_process(delta):
	velocity = Vector2()
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1
		
	velocity = velocity.normalized() * SPEED
	velocity = move_and_slide(velocity)
	position += velocity * delta
	position.normalized()
	position.y = clamp(position.y,0,534)
	position.x = clamp(position.x,0,990)

	