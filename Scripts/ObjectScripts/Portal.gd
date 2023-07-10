@tool
extends Area2D

@export var next_scene: PackedScene

var bodycount = 0
var bodies = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("START")
	$AnimatedSprite2D.play("portal")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if bodycount == 2:
		teleport()


func teleport():
	$AnimationPlayer.play("fade_in")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_packed(next_scene)


func _on_body_entered(body):
	if body not in bodies:
		bodycount += 1
		bodies.append(body)


func _on_body_exited(body):
	if body in bodies:
		bodycount -= 1
		bodies.erase(body)
