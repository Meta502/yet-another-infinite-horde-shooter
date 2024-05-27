extends Node2D

func _unhandled_input(event):
	if event is InputEventKey and event.is_pressed():
		if event.keycode == 77:
			Settings.mute_bgm = !Settings.mute_bgm
			$MenuMusic.playing = not Settings.mute_bgm

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/MainScene.tscn")
