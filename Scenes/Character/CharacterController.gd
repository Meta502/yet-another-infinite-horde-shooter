extends CharacterBody2D

@onready var main = get_node("/root/MainScene")

signal shoot

const ACCELERATION = 12000.0
var FRICTION = 0.9

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var camera: Camera2D
var can_shoot: bool
var spawned: bool
var sprite_scale: Vector2
var alive: bool

var rng = RandomNumberGenerator.new()

func _ready():
	camera = get_node("Camera2D")
	can_shoot = true
	spawned = false
	alive = true
	sprite_scale = $SpriteWrapper/AnimatedSprite2D.scale
	$SpriteWrapper/AnimatedSprite2D.play("default")

func handle_input():
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_shoot:
		var dir = get_global_mouse_position() - position
		var bullet_array = [0]
		for i in range(main.projectiles):
			if i > 0:
				bullet_array.insert(0, deg_to_rad(i * -2.5))
				bullet_array.append(deg_to_rad(i * 2.5))
		
		for bullet in bullet_array:
			shoot.emit(position, dir.rotated(bullet)) 
				
		can_shoot = false
		$ShootSFX.play()
		$ShotTimer.start()

func handle_movement(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	velocity *= FRICTION

	var mouse = get_local_mouse_position()
	var angle = mouse.angle()

	var horizontal_direction = Input.get_axis("left", "right")
	var vertical_direction = -Input.get_axis("down", "up")

	var mouse_delta = mouse.normalized()

	if mouse_delta.x > 0:
		$SpriteWrapper/AnimatedSprite2D.scale.x = sprite_scale.x
	elif mouse_delta.x < 0:
		$SpriteWrapper/AnimatedSprite2D.scale.x = -sprite_scale.x

	if int(velocity.length()) > 0:
		$SpriteWrapper/AnimatedSprite2D.play("walk")
	elif spawned:
		$SpriteWrapper/AnimatedSprite2D.play("idle")

	var direction = Vector2(horizontal_direction, vertical_direction).normalized()
	var strafe_accel = ACCELERATION
	var speed_limit = main.movement_speed

	var current_speed = direction.dot(velocity)
	var accel = strafe_accel * delta

	accel = max(0, min(accel, speed_limit - current_speed))
	velocity += direction * accel

func _physics_process(delta):
	if alive:
		handle_movement(delta)
		handle_input()
		move_and_slide()

func _on_shot_timer_timeout():
	can_shoot = true

func _on_spawn_timer_timeout():
	spawned = true
