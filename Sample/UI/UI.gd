extends CanvasLayer


const heart_full = preload("res://Assets/HeartIcons/hud_heartFull.png")
const heart_half = preload("res://Assets/HeartIcons/hud_heartHalf.png")
const heart_empty = preload("res://Assets/HeartIcons/hud_heartEmpty.png")

onready var level_num = $Boards/LevelBoard/VBoxContainer/LevelNum
onready var hearts = $Boards/LifeBoard/VBoxContainer/HeartsContainer
onready var power_num = $Boards/PowerBoard/VBoxContainer/PowerNum

func update_level(level):
	level_num.text = str(level)

func update_life(life):
	print("update_life called")
	for i in hearts.get_child_count():
		if life > i * 2 + 1:
			hearts.get_child(i).texture = heart_full
		elif life > i * 2:
			hearts.get_child(i).texture = heart_half
		else:
			hearts.get_child(i).texture = heart_empty
	
func update_power(power):
	power_num.text = str(power)
