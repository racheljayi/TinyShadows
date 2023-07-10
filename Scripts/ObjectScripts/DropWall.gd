extends AnimatableBody2D

var up = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("move_down")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_drop_wall_container_switched():
	if up == false:
		$AnimationPlayer.play("move_up")
		up = true
	else:
		$AnimationPlayer.play("move_down")
		up = false
