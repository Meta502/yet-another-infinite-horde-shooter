extends Node2D

@export var MAX_ENEMIES = 20

var difficulty = 1
var lives: int
var time_elapsed: float = 0

var zombie_scene := preload("res://Scenes/Enemies/Zombie.tscn")
var archer_scene := preload("res://Scenes/Enemies/Archer.tscn")

var spawn_table := [
	{
		"scene": zombie_scene,
		"minimum_level": 1
	},
	{
		"scene": archer_scene,
		"minimum_level": 3
	}
]

var spawn_pool := [
	{
		"scene": zombie_scene,
		"minimum_level": 1
	}
]

func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)

func _ready():
	lives = 3
	$Camera2D/HUD/Health/Label.text = "X" + str(lives)

func _physics_process(delta):
	MAX_ENEMIES = (difficulty + 1) * 3
	
	$Camera2D/HUD/Health/Label.text = "X" + str(lives)
	$Camera2D/HUD/Level/Label2.text = "Level: " + str(difficulty)
	$Camera2D/HUD/Time/Label.text = "%.2fs" % time_elapsed
	
	if $CharacterController.alive:
		time_elapsed += delta
		if lives == 0:
			$CharacterController.alive = false
			$CharacterController/SpriteWrapper/AnimatedSprite2D.play("death")

func _on_difficulty_timer_timeout():
	difficulty += 1
	spawn_pool = spawn_table.filter(func(spawnable): return spawnable["minimum_level"] <= difficulty)

func _on_enemy_spawner_hit_p():
	if lives > 0:
		lives -= 1
