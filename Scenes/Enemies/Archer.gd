extends CharacterBody2D

@onready var player = get_node("/root/MainScene/CharacterController")
@onready var main = get_node("/root/MainScene")
@onready var item_manager = get_node("/root/MainScene/ItemManager")

var bullet_scene = preload("res://Scenes/Objects/Arrow.tscn")

signal hit_player
signal shoot_player

var health: int
var speed: int = 150
var direction: Vector2 

var approach_angle = PI/3

var rng = RandomNumberGenerator.new()

func _ready():
	var rotation_direction = bool(rng.randi_range(0, 2))
	if rotation_direction:
		approach_angle *= -1

	$DirectionTimer.wait_time = rng.randf_range(3, 5)
	$DirectionTimer.start()
	$AnimatedSprite2D.play("default")
	health = 1

func _physics_process(delta):
	if health > 0:
		direction = player.position - position
		
		direction = direction.normalized().rotated(approach_angle)
		velocity = direction * speed
		move_and_slide()
	else:
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.self_modulate = Color("#be7600")
		die()
		
func die():
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	if $DespawnTimer.is_stopped():
		$DespawnTimer.start()
	drop_item()

func drop_item():
	pass

func _on_area_2d_body_entered(body):
	hit_player.emit()

func _on_despawn_timer_timeout():
	var random_float = randf()
	
	if random_float > 0.8:
		item_manager.drop_random_item(position)
	queue_free()

func _on_direction_timer_timeout():
	approach_angle *= -1
	$DirectionTimer.wait_time = rng.randi_range(3, 8)
	$DirectionTimer.start()

func _on_attack_timer_timeout():
	if health > 0 and (player.position - position).length() < 800:
		var dir = (player.position + player.velocity * rng.randf_range(0, 0.5)) - position
		var bullet = bullet_scene.instantiate()
		
		main.add_child(bullet)
		bullet.position = position
		bullet.direction = dir.normalized()
		bullet.add_to_group("bullets")
