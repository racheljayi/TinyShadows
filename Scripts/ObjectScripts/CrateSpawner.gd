extends Node

@onready var crate = preload("res://Objects/Crate.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("reset"):
		destroy()
		respawn()

func destroy():
	if self.get_child_count() > 0:
		self.get_child(0).queue_free()

func respawn():
	var new_crate = crate.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	new_crate.position = Vector2(-425, 72)
	self.add_child(new_crate)
