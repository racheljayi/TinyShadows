extends Control

@export var first_scene : PackedScene

func _ready():
	$VBoxContainer/StartButton.grab_focus()


func _process(_delta):
	pass


func _on_start_button_pressed():
	$AudioStreamPlayer.play()
	await $AudioStreamPlayer.finished
	get_tree().change_scene_to_packed(first_scene)

func _on_options_button_pressed():
	$AudioStreamPlayer.play()
	await $AudioStreamPlayer.finished
	get_tree().quit()
