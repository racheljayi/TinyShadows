extends Camera2D

var move_speed = 0.5  # camera position lerp speed
var zoom_speed = 0.25  # camera zoom lerp speed
var min_zoom = 1.5  # camera won't zoom closer than this
var max_zoom = 8  # camera won't zoom farther than this
var margin = Vector2(400, 200)  # include some buffer area around targets
var multiplier = 3

func _ready():
	pass

@onready var targets = get_tree().get_nodes_in_group("players")
@onready var screen_size = get_viewport_rect().size

func _process(_delta):
	var p = Vector2.ZERO
	for target in targets:
		p += target.position
	p /= targets.size()
	position = lerp(position, p, move_speed)

	var r = Rect2(position, Vector2.ONE)
	for target in targets:
		r = r.expand(target.position)
	r = r.grow_individual(margin.x, margin.y, margin.x, margin.y)
	var z
	if r.size.x > r.size.y * screen_size.aspect():
		z = clamp((screen_size.x / r.size.x)*multiplier, min_zoom, max_zoom)
	else:
		z = clamp((screen_size.y / r.size.y)*multiplier, min_zoom, max_zoom)
	zoom = lerp(zoom, Vector2.ONE * z, zoom_speed)
	



func _on_level_two_tree_entered():
	multiplier = 2.3


func _on_level_three_tree_entered():
	multiplier = 1.9


func _on_level_five_tree_entered():
	multiplier = 3.0


func _on_npc_game_end():
	multiplier = lerp(multiplier, 1.5, 0.005)
