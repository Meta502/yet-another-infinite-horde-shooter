extends Node2D

@onready var main = get_node("/root/MainScene")

var rng = RandomNumberGenerator.new()

var item_scene = preload("res://Scenes/Items/Item.tscn")

var item_tables = [
	{
		"id": "life_potion",
		"sprite": preload("res://Resources/NinjaAdventure/Items/Potion/LifePot.png"),
		"display_name": "Life Potion",
		"description": "Increases your max health",
		"weight": 10
	},
	{
		"id": "medkit",
		"sprite": preload("res://Resources/NinjaAdventure/Items/Potion/Hear.png"),
		"display_name": "Medkit",
		"description": "Heals your character",
		"weight": 80
	},
	{
		"id": "shotgun",
		"sprite": preload("res://Resources/VladPennWeaponPack/Shotgun.png"),
		"display_name": "Shotgun",
		"description": "Adds additional projectiles to attack",
		"weight": 10
	}
	#{
		#"id": "running_shoes",
		#"display_name": "Running Shoes",
		#"description": "Increases movement speed",
		#"weight": 20,
	#},
	#{
		#"id": "machine_gun",
		#"display_name": "Machine Gun",
		#"description": "Increases weapon fire rate",
		#"weight": 20
	#}
]

var inventory = {}

var weights_acc := []

func _ready():
	weights_acc.resize(item_tables.size())
	var weights_sum := 0.0
	for i in weights_acc.size():
		weights_sum += item_tables[i]["weight"]
		weights_acc[i] = weights_sum

func choice_binary(weights_acc: Array, rng: RandomNumberGenerator) -> int:
	var weight_threshold := rng.randf_range(0.0, weights_acc.back())
	return weights_acc.bsearch(weight_threshold)

func drop_random_item(pos):
	var i = choice_binary(weights_acc, rng)
	var dropped_item = item_tables[i]
	
	var item = item_scene.instantiate()
	item.position = pos
	item.update_item(dropped_item)
	item.pickup_item.connect(_on_pickup_item)
	main.call_deferred("add_child", item)
	item.add_to_group("items")
	
func _on_pickup_item(id):
	if id not in inventory:
		inventory[id] = 0
	inventory[id] += 1
	
	if id == "medkit":
		if main.lives < main.max_lives:
			main.lives += 1
	elif id == "life_potion":
		main.max_lives += 1
	elif id == "shotgun":
		if main.projectiles < 10:
			main.projectiles += 1
