extends Node2D


signal attack_done

const damage_scn = preload("res://Signs/Damage.tscn")

export (String) var color 
export (int) var max_life = 100
export (float) var attack_interval = 10.0

var life = 100

onready var life_bar = $Bars/LifeBar
onready var life_value = $Bars/LifeValue
onready var attack_bar = $Bars/AttackBar
onready var damage_position = $DamagePosition
onready var attack_timer = $AttackTimer
onready var anim_player = $AnimationPlayer
onready var attack_sound = $AttackSound
onready var hit_sound = $HitSound
onready var die_sound = $DieSound


func _ready():
	randomize()
	attack_timer.start()


func set_level(level):
	if level > 1:
		max_life = int(max_life * level * rand_range(0.456, 0.543))
		attack_interval -= level * 0.1
	life = max_life
	
	get_node("Bars/LifeBar").max_value = life
	get_node("Bars/LifeBar").value = life
	get_node("Bars/LifeValue").text = str(life) + "/" + str(life)
	get_node("Bars/AttackBar").max_value = attack_interval
	get_node("Bars/AttackBar").value = 0
	get_node("AttackTimer").wait_time = attack_interval


func _process(_delta):
	update_speed_bar()


func update_speed_bar():
	attack_bar.value = attack_interval - attack_timer.time_left
	

func _on_AttackTimer_timeout():
	attack()


func attack():
	anim_player.play("attack")
	attack_sound.play()


func hit(damage, combo):
	if anim_player.current_animation == "attack":
		yield(anim_player, "animation_finished")
	for i in combo:
		anim_player.play("hit")
		hit_sound.play()
		life = int(max(life - damage - i, 0))
		update_lifebar()
		spawn_damage(damage + i)
		yield(get_tree().create_timer(0.1), "timeout")
	if life > 0:
		attack_timer.paused = false
		yield(anim_player, "animation_finished")
		anim_player.play("idle")
	else:
		anim_player.play("die")
		die_sound.play()


func update_lifebar():
	life_bar.value = life
	life_value.text = str(life) + "/" + str(max_life)


func spawn_damage(damage):
	var damage_obj = damage_scn.instance()
	damage_obj.position = damage_position.position
	get_parent().add_child(damage_obj)
	damage_obj.damage_label.text = str(damage)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "attack":
		emit_signal("attack_done")
		attack_timer.start()
		anim_player.play("idle")
	elif anim_name == "die":
		queue_free()


