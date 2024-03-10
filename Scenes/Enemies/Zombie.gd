extends CharacterBody2D

@onready var player = get_node("/root/MainScene/CharacterController")
@onready var main = get_node("/root/MainScene")

signal hit_player

var health: int
var speed: int = 125
var direction: Vector2 

func _ready():
	health = 1
	speed = 100 + clamp(int(main.difficulty / 2) * 25, 25, 100)

func _physics_process(delta):
	if health > 0:
		direction = player.position - position
		direction = direction.normalized()
		velocity = direction * speed
		move_and_slide()
	else:
		die()

func die():
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	if $DespawnTimer.is_stopped():
		$DespawnTimer.start()

func _on_area_2d_body_entered(body):
	hit_player.emit()

func _on_despawn_timer_timeout():
	queue_free()
