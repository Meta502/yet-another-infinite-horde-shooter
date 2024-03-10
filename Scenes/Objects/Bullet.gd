extends Area2D

var speed: float = 1500
var direction: Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += speed * direction * delta

func _on_timer_timeout():
	queue_free()

func _on_body_entered(body):
	if body.name == "TileMap":
		queue_free()
	else:
		if body.health:
			body.health -= 1
			queue_free()
