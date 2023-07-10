extends CharacterBody2D

var on = true

func _ready():
	pass

func _physics_process(_delta):
	if on == false:
		self.visible = false
		$CollisionShape2D.disabled = true
	else:
		self.visible = true
		$CollisionShape2D.disabled = false

func _triggered():
	on = not on
	# for lever

func _released():
	on = true


func _on_lever_1_switched():
	call_deferred("_triggered")


func _on_button_pressed_down():
	call_deferred("_triggered")


func _on_button_released():
	call_deferred("_released")


func _on_button_2_pressed_down():
	pass # Replace with function body.


func _on_button_2_released():
	pass # Replace with function body.


func _on_lever_6_switched():
	call_deferred("_triggered")


func _on_lever_7_switched():
	call_deferred("_triggered")
