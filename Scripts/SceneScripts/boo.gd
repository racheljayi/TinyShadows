extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_player_1_boo():
	self.visible = true
	$BooTimer.start()
	await $BooTimer.timeout
	self.visible = false


func _on_player_2_boo():
	self.visible = true
	$BooTimer.start()
	await $BooTimer.timeout
	self.visible = false
