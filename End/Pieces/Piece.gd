extends Area2D

signal collided(self_piece)

export (String) var color

var matched = false
var matched_index = 0
var held = false
var offset = Vector2(35, -35)

onready var sprite = $Sprite
onready var tween = $Tween


func _process(_delta):
	if held:
		position = get_global_mouse_position() - offset


func move(destination):
	tween.interpolate_property(self, "position", position, destination, .1, Tween.TRANS_QUINT, Tween.EASE_IN)
	tween.start()


func make_matched(index):
	matched = true
	matched_index = index
	modulate = Color(1,1,1,.5)


func enable_held():
	held = true
	modulate = Color(1, 1, 1, 0.8)


func disable_held():
	held = false
	modulate = Color(1, 1, 1, 1)


func _on_Piece_area_entered(area):
	if area.is_in_group("Pieces") and area.held:
		emit_signal("collided", self)
