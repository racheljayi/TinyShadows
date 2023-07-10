extends Node2D

@export var first_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _enter_tree():
	await $Timer.timeout
	$CanvasLayer/Label.visible = true
	$Timer.start()
	await $Timer.timeout
	$CanvasLayer/Label2.visible = true
	$Timer.start()
	await $Timer.timeout
	$CanvasLayer/Label3.visible = true
	$Timer.start()
	await $Timer.timeout
	$CanvasLayer/Label4.visible = true
	$Timer.start()
	await $Timer.timeout
	$Timer.start()
	await $Timer.timeout
	get_tree().change_scene_to_packed(first_scene)
	
