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
	on = not on
	$Timer.start()
	await $Timer.timeout
	on = not on

func _released():
	pass


func _on_lever_2_switched():
	call_deferred("_triggered")
