extends Area2D

var pressed = false
signal pressed_down
signal released

func _ready():
	pass 


func _process(_delta):
	if pressed == true:
		$AnimatedSprite2D.play("button1-down")
	else:
		$AnimatedSprite2D.play("button1-up")


func _on_body_entered(_body):
	pressed = true
	pressed_down.emit()


func _on_body_exited(_body):
	pressed = false
	released.emit()
