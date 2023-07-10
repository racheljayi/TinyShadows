extends Node2D

var inOne = false
var inFive = false
var inArea = false
var boo1 = false
var boo2 = false
var scared = false
var running = false
signal game_end
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update_animation()
	if inOne:
		$NPCBody/AnimationPlayer.play("move")
		await $NPCBody/AnimationPlayer.animation_finished
		self.queue_free()
	if inFive:
		if inArea:
			if Input.is_action_pressed("p1_action"): boo1 = true
			if Input.is_action_pressed("p2_action"): boo2 = true

func _on_level_one_tree_entered():
	$NPCBody/AnimatedSprite2D.play("idle")
	await $NPCBody/AnimatedSprite2D.animation_finished
	inOne = true
	running = true

func _on_level_five_tree_entered():
	inFive = true

func _on_end_area_body_entered(_body):
	inArea = true
	
func update_animation():
	if boo1 and boo2 and not scared:
		$NPCBody/AnimatedSprite2D.flip_h = true
		$NPCBody/AnimatedSprite2D.play("scare")
		await $NPCBody/AnimatedSprite2D.animation_finished
		scared = true
	elif scared:
		$NPCBody/AnimatedSprite2D.play("shake")
		game_end.emit()
	elif running:
		$NPCBody/AnimatedSprite2D.play("running")
	else:
		$NPCBody/AnimatedSprite2D.play("idle")
