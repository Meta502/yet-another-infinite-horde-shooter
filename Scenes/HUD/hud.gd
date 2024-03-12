extends CanvasLayer

@onready var main = get_node("/root/MainScene")

var time_elapsed = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_player_died():
	$GameHUD.visible = false
	$DeathScreen.visible = true
	$DeathScreen/Control/YouDied2.text = "You survived for %.2fs" % time_elapsed

func _ready():
	$GameHUD.visible = true
	$DeathScreen.visible = false
	main.player_died.connect(_on_player_died)

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/MainScene.tscn")
