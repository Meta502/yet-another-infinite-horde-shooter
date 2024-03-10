extends CharacterBody2D

@onready var player = get_node("/root/MainScene/CharacterController")
@onready var main = get_node("/root/MainScene")

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
	health = 1

func _physics_process(delta):
	if health > 0:
		direction = player.position - position
		
		direction = direction.normalized().rotated(approach_angle)
		velocity = direction * speed
		move_and_slide()
	else:
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
	queue_free()

func _on_direction_timer_timeout():
	approach_angle *= -1
	$DirectionTimer.wait_time = rng.randi_range(3, 8)
	$DirectionTimer.start()

func _on_attack_timer_timeout():
	if health > 0:
		var dir = (player.position + player.velocity * 1/90) - position
		var bullet = bullet_scene.instantiate()
		
		main.add_child(bullet)
		bullet.position = position
		bullet.direction = dir.normalized()
		bullet.add_to_group("bullets")
