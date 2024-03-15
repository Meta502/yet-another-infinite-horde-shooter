extends Node2D

@onready var main = get_node("/root/MainScene")

var player: CharacterBody2D
var instance_count = 0
var rng = RandomNumberGenerator.new()

signal enemy_killed
signal enemy_spawned
signal hit_p

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	player = get_parent().get_node("CharacterController") 
	
func hit():
	hit_p.emit()

func choice_binary(weights_acc: Array, rng: RandomNumberGenerator) -> int:
	var weight_threshold := rng.randf_range(0.0, weights_acc.back())
	return weights_acc.bsearch(weight_threshold)

func choose_enemy():
	var i = choice_binary(main.weights_acc, rng)
	var enemy = main.spawn_pool[i]
	
	return enemy

func spawn_enemies():
	var enemies = get_tree().get_nodes_in_group("enemies")
	
	if enemies.size() < get_parent().MAX_ENEMIES:
		var amount_of_enemies = get_parent().MAX_ENEMIES - enemies.size()
		
		for i in range(min(amount_of_enemies, main.difficulty * 4)):
			var enemy = choose_enemy()["scene"]
			
			var _distance = rng.randf_range(800, 1200)
			var _angle = rng.randf_range(0, 360)

			var spawn_point = player.position + Vector2(1,0).rotated(deg_to_rad(_angle)) * _distance

			var enemy_instance = enemy.instantiate()
			enemy_instance.position = spawn_point

			main.add_child(enemy_instance)
			enemy_instance.hit_player.connect(hit)
			enemy_instance.add_to_group("enemies")

func _on_spawn_timer_timeout():
	spawn_enemies()
