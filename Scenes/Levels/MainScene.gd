extends Node2D

@export var MAX_ENEMIES = 20

signal player_died

var difficulty = 1
var time_elapsed: float = 0

var zombie_scene := preload("res://Scenes/Enemies/Zombie.tscn")
var archer_scene := preload("res://Scenes/Enemies/Archer.tscn")

var alive = true

var lives: int
var max_lives = 0
var movement_speed = 0
var projectiles = 1

var weights_acc := []
var spawn_table := [
	{
		"scene": zombie_scene,
		"minimum_level": 1,
		"weight": 70,
	},
	{
		"scene": archer_scene,
		"minimum_level": 3,
		"weight": 30,
	}
]

var spawn_pool := spawn_table.filter(func(spawnable): return spawnable["minimum_level"] <= difficulty)

func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)

func _ready():
	lives = 3
	movement_speed = 300
	max_lives = 3
	$Camera2D/HUD/GameHUD/Health/Label.text = str(lives) + "/" + str(max_lives)
	weights_acc.resize(spawn_pool.size())
	var weights_sum := 0.0
	for i in weights_acc.size():
		weights_sum += spawn_pool[i]["weight"]
		weights_acc[i] = weights_sum

func _physics_process(delta):
	MAX_ENEMIES = (difficulty + 1) * 3
	
	$Camera2D/HUD/GameHUD/Health/Label.text = str(lives) + "/" + str(max_lives)
	$Camera2D/HUD/GameHUD/Level/Label2.text = "Level: " + str(difficulty)
	$Camera2D/HUD/GameHUD/Time/Label.text = "%.2fs" % time_elapsed
	
	if $CharacterController.alive:
		time_elapsed += delta
		if lives == 0:
			alive = false
			$CharacterController.alive = false
			$CharacterController/SpriteWrapper/AnimatedSprite2D.play("death")
			$Camera2D/HUD.time_elapsed = time_elapsed
			player_died.emit()

func _on_difficulty_timer_timeout():
	difficulty += 1
	spawn_pool = spawn_table.filter(func(spawnable): return spawnable["minimum_level"] <= difficulty)
	weights_acc.resize(spawn_pool.size())
	var weights_sum := 0.0
	for i in weights_acc.size():
		weights_sum += spawn_pool[i]["weight"]
		weights_acc[i] = weights_sum

func _on_enemy_spawner_hit_p():
	if lives > 0:
		lives -= 1
