extends Control

var main_menu_scene = preload("res://Scenes/Levels/MenuScene.tscn")

var slideshow_nodes: Array[PanelContainer]
var current_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	slideshow_nodes = [$NameContainer, $MakaraContainer, $CreditsContainer]

func _on_timer_timeout():
	slideshow_nodes[current_index].visible = false
	current_index += 1
	if current_index < len(slideshow_nodes):
		slideshow_nodes[current_index].visible = true
	else:
		get_tree().change_scene_to_packed(main_menu_scene)
