extends Node2D

var zombie_scene := preload("res://Scenes/Enemies/Zombie.tscn")
var parent: CharacterBody2D
var camera: Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_parent().get_node("Camera2D")
	parent = get_parent()
