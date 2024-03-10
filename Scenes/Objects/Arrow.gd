extends Area2D

@onready var main = get_node("/root/MainScene")

var speed: float = 300
var direction: Vector2

signal hit_player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += speed * direction * delta

func _on_timer_timeout():
	queue_free()


func _on_body_entered(body):
	if body.name == "TileMap":
		queue_free()
	elif body.name == "CharacterController":
		main.lives -= 1
		queue_free()
