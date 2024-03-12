extends CharacterBody2D

@onready var player = get_node("/root/MainScene/CharacterController")
@onready var main = get_node("/root/MainScene")
@onready var item_manager = get_node("/root/MainScene/ItemManager")

signal hit_player

var health: int
var speed: int = 125
var direction: Vector2 

func _ready():
	health = 1
	speed = 100 + clamp(int(main.difficulty / 2) * 25, 25, 100)
	$AnimatedSprite2D.play("default")

func _physics_process(delta):
	if health > 0:
		direction = player.position - position
		direction = direction.normalized()
		velocity = direction * speed
		move_and_slide()
	else:
		$AnimatedSprite2D.stop()
		die()

func die():
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite2D.self_modulate = Color("#be7600")
	if $DespawnTimer.is_stopped():
		$DespawnTimer.start()

func _on_area_2d_body_entered(body):
	hit_player.emit()

func _on_despawn_timer_timeout():
	var random_float = randf()

	if random_float > 0.8:
		item_manager.drop_random_item(position)
	queue_free()
