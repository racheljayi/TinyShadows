extends Node2D

signal switched

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_lever_8_switched():
	switched.emit()


func _on_button_pressed_down():
	switched.emit()


func _on_button_released():
	switched.emit()


func _on_button_2_pressed_down():
	switched.emit()


func _on_button_2_released():
	switched.emit()


func _on_button_3_pressed_down():
	switched.emit()


func _on_button_3_released():
	switched.emit()


func _on_lever_1_switched():
	switched.emit()


func _on_lever_2_switched():
	switched.emit()
