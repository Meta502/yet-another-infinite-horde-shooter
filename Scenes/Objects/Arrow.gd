extends Area2D

@onready var main = get_node("/root/MainScene")
@onready var player = get_node("/root/MainScene/CharacterController")

var speed: float = 300
var direction: Vector2

signal hit_player

func _ready():
	$AnimatedSprite2D.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += speed * direction * delta
	rotation = direction.angle() - PI

func _on_timer_timeout():
	queue_free()

func _on_body_entered(body):
	if body.name == "TileMap":
		queue_free()
	elif body.name == "CharacterController":
		main.lives -= 1
		player.play_hit_sound()
		queue_free()
