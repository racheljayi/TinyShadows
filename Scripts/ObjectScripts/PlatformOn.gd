extends CharacterBody2D

var on = false

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
	on = true

func _released():
	on = false

func _on_button_pressed_down():
	call_deferred("_triggered")


func _on_button_released():
	call_deferred("_released")


func _on_button_2_pressed_down():
	call_deferred("_triggered")


func _on_button_2_released():
	call_deferred("_released")
