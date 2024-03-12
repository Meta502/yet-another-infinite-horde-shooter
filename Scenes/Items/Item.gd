extends Node2D

var id: String
var display_name: String
var description: String
var sprite_image: Texture

var lifespan: float = 10

signal pickup_item

func update_item(metadata):
	id = metadata["id"]
	display_name = metadata["display_name"]
	description = metadata["description"]
	sprite_image = metadata["sprite"]
	$Sprite.texture = sprite_image

func _physics_process(delta):
	lifespan -= delta
	if lifespan < 3 and $FlashTimer.is_stopped():
		$FlashTimer.start()
	elif lifespan < 0:
		queue_free()

func _on_body_entered(body):
	if body.name == "CharacterController":
		$Sprite.queue_free()
		$CollisionShape2D.queue_free()
		pickup_item.emit(id)
		$AudioStreamPlayer2D.play()
		
		await $AudioStreamPlayer2D.finished
		queue_free()

func _on_flash_timer_timeout():
	if $Sprite:
		$Sprite.visible = !$Sprite.visible
