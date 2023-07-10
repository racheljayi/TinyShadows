extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("pulse")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass



func _on_body_entered(_body):
	$AnimatedSprite2D.play("explode")
	await $AnimatedSprite2D.animation_finished
	self.visible = false
	$CollisionShape2D.disabled = true
	$ResetTimer.start()
	await $ResetTimer.timeout
	self.visible = true
	$CollisionShape2D.disabled = false
	$AnimatedSprite2D.play("pulse")
