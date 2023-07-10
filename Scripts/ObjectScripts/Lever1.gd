extends Area2D

var on = false
signal switched

func _ready():
	pass 


func _process(_delta):
	if on == false:
		$AnimatedSprite2D.play("lever-left")
	else:
		$AnimatedSprite2D.play("lever-right")


func _on_area_entered(area):
	if area.is_in_group("Weapon"):
		on = not on
		switched.emit()
