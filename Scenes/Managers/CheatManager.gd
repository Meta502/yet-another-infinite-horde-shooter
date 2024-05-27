extends Control

@onready var main = get_node("/root/MainScene")

const CHEAT_LIST = {
	"UUDDLRLRDU": ["KONAMI_CODE", "+5 MAX HEALTH, +2 SHOTGUN LEVEL, HEAL TO FULL"],
	"UUDDUUDD": ["I_AM_SPEED", "+10 SPEED UP"],
	"LLLRRRLL": ["EAT_LEAD" , "+3 SHOTGUN LEVEL"]
}

var cheats_used = {}

var current_cheat_string = ""

func handle_input():
	if (
		not Input.is_action_just_pressed("CHEAT_DOWN")
		and not Input.is_action_just_pressed("CHEAT_UP")
		and not Input.is_action_just_pressed("CHEAT_LEFT")
		and not Input.is_action_just_pressed("CHEAT_RIGHT")
	):
		return
	
	if Input.is_action_just_pressed("CHEAT_UP"):
		current_cheat_string += "U"
		$DebounceTimer.start()
	elif Input.is_action_just_pressed("CHEAT_DOWN"):
		current_cheat_string += "D"
		$DebounceTimer.start()
	elif Input.is_action_just_pressed("CHEAT_LEFT"):
		current_cheat_string += "L"
		$DebounceTimer.start()
	elif Input.is_action_just_pressed("CHEAT_RIGHT"):
		current_cheat_string += "R"
		$DebounceTimer.start()

func handle_cheat():
	var cheat = CHEAT_LIST.get(current_cheat_string)
	if cheat:
		if cheats_used.get(cheat[0]):
			$CanvasLayer/Container/CheatLabel.text = cheat[0] + " ALREADY ACTIVATED"
			$CanvasLayer/Container/LabelTimer.start()
			current_cheat_string = ""
			return
		
		$CanvasLayer/Container/CheatLabel.text = cheat[0] + " ACTIVATED\n" + cheat[1]
		$CanvasLayer/Container/LabelTimer.start()
		cheats_used[cheat[0]] = true
		
		if cheat[0] == "KONAMI_CODE":
			main.max_lives += 5
			main.lives = main.max_lives
			main.projectiles += 2
		if cheat[0] == "I_AM_SPEED":
			main.movement_speed *= 1.035**10
		if cheat[0] == "EAT_LEAD":
			main.projectiles = clamp(main.projectiles + 3, 1, 10)
		
		current_cheat_string = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_input()
	handle_cheat()


func _on_debounce_timer_timeout():
	print("RESET CHEAT STRING")
	current_cheat_string = ""


func _on_label_timer_timeout():
	$CanvasLayer/Container/CheatLabel.text = ""
