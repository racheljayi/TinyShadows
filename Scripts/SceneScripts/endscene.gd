extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	blink()

func blink():
	if $Timer.is_stopped():
		$CanvasLayer/Label.visible = not $CanvasLayer/Label.visible
		$Timer.start()
