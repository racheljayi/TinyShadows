extends CanvasLayer

@export var player1: Node
@export var player2: Node
@export var end_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update_charge_display()

func update_charge_display():
	$ChargeDisplay1.text = str(player1.charges)
	$ChargeDisplay2.text = str(player2.charges2)


func _on_npc_game_end():
	$AnimationPlayer.play("title card")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_packed(end_scene)
