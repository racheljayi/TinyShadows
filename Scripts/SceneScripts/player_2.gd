extends CharacterBody2D

# i am using a very rudimentary brute-force method for switching
# a FSM would be better to implement more complexity

# enum Forms {SPECTER, SHADE, SPIRIT}
var form = "SPECTER" #current form, default SPECTER
var shade = false #has shade been unlocked
var spirit = false #has spirit been unlocked
var charges2 = 0 #switchcount

#movement stats
const SPEED = 100.0
const DASH_SPEED = 280.0
const BOUNCE_SPEED = 150.0
const ACCELERATION = 700.0
const FRICTION = 1000.0
const JUMP_VELOCITY = -200.0
const AIR_RESIST = 200.0
const AIR_ACCELERATION = 400.0
const PUSH_FORCE = 1800.0

#jump stats
var jump_count = 0
var jump_max = 2
var just_wall_jumped = false
var was_wall_normal = Vector2.ZERO
var dashing = false
var attacking = false
var switching = false
var spawning = false

signal boo

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var current_sprite = $AnimatedSprite2D
@onready var attack_collision_r = $AttackArea/AttackCollisionR
@onready var attack_collision_l = $AttackArea/AttackCollisionL
@onready var wall_jump_timer = $WallJumpTimer
@onready var dashing_timer = $DashingTimer


func _physics_process(delta):
	if form == "SPECTER":
		set_collision_mask_value(4, false)
	else:
		set_collision_mask_value(4, true)
	dashing = dashing_timer.time_left > 0
	if not attacking:
		attack_collision_r.set_deferred("disabled", true)
		attack_collision_l.set_deferred("disabled", true)
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("p2_action"):
		action()
	
	if Input.is_action_just_pressed("p2_switch"):
		switch()

	wall_jump()
	jump()
	
	var input_axis = Input.get_axis("p2_move_left", "p2_move_right")
			
	if not dashing:
		accelerate(input_axis, delta)
		air_accelerate(input_axis, delta)
	
	apply_friction(input_axis, delta)
	apply_air_resist(input_axis, delta)

	var was_on_wall = is_on_wall_only()
	if was_on_wall:
		was_wall_normal = get_wall_normal()

	move_and_slide()
	
	just_wall_jumped = false
	var just_left_wall = was_on_wall and not is_on_wall()
	if just_left_wall:
		wall_jump_timer.start()
	
	if dashing: 
		velocity.y = 0
	
	for i in get_slide_collision_count():
		var col = get_slide_collision(i)
		if col.get_collider() is RigidBody2D:
			col.get_collider().apply_force(col.get_normal() * -PUSH_FORCE)
		
	update_animations(input_axis)

func jump():
	if is_on_floor():
		jump_count = 0
	if jump_count < jump_max: 
		if is_on_floor() or form == "SPECTER":
			if Input.is_action_just_pressed("p2_move_up"):
				velocity.y = JUMP_VELOCITY
				jump_count += 1
				$Jump.play()
		elif not is_on_floor():
			if Input.is_action_just_released("p2_move_up") and velocity.y < JUMP_VELOCITY / 2:
				velocity.y = JUMP_VELOCITY / 2
				jump_count += 1
				$Jump.play()
			if Input.is_action_just_pressed("p2_move_up") and not just_wall_jumped:
				velocity.y = JUMP_VELOCITY * 0.8
				jump_count += 1
				$Jump.play()


func wall_jump():
	if form != "SHADE": return
	if not is_on_wall_only() and wall_jump_timer.time_left <= 0.0: return
	var wall_normal = get_wall_normal() 
	if wall_jump_timer.time_left > 0.0:
		wall_normal = was_wall_normal
	if Input.is_action_just_pressed("p2_move_up"):
		if is_on_wall_only():
			velocity.x = wall_normal.x * BOUNCE_SPEED  
		velocity.y = JUMP_VELOCITY
		$Jump.play()
		just_wall_jumped = true

func accelerate(input_axis, delta):
	if not is_on_floor(): return
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, SPEED * input_axis, ACCELERATION * delta)

func air_accelerate(input_axis, delta):
	if is_on_floor(): return
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, SPEED * input_axis, AIR_ACCELERATION * delta)

func apply_friction(input_axis, delta):
	if input_axis == 0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

func apply_air_resist(input_axis, delta):
	if input_axis == 0 and not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, AIR_RESIST * delta)

func action():
	if form == "SPECTER" and not dashing:
		dashing_timer.start()
		if current_sprite.flip_h == false:
			velocity.x = DASH_SPEED
		else:
			velocity.x = -DASH_SPEED
	if form == "SHADE" and not attacking: 
		attacking = true
		if current_sprite.flip_h == false:
			attack_collision_r.set_deferred("disabled", false)
		else:
			attack_collision_l.set_deferred("disabled", false)
	if form == "SPIRIT":
		boo.emit()

func switch():
	if charges2 == 0: return
	if shade == false: return
	if spirit == true:
		form = "SPIRIT"
		jump_max = 5
	else:
		if form == "SPECTER":
			form = "SHADE"
			jump_max = 1
		elif form == "SHADE":
			form = "SPECTER"
			jump_max = 2
	charges2 -= 1
	switching = true

func update_animations(input_axis):
	if input_axis != 0:
			current_sprite.flip_h = (input_axis < 0)
	if spawning:
		current_sprite.play("spec-spawn")
		await current_sprite.animation_finished
		spawning = false
	if form == "SPECTER":
		if switching and not spirit:
			$Switch.play()
			current_sprite.play("shade-switch-out-tspec")
			await current_sprite.animation_finished
			switching = false
		elif dashing:
			current_sprite.play("spec-dash")
		elif not is_on_floor():
			current_sprite.play("spec-jump")
		else:
			current_sprite.play("spec-walk")
			
	elif form == "SHADE":
		if switching and not spirit:
			$Switch.play()
			current_sprite.play("spec-switch-out-tshade")
			await current_sprite.animation_finished
			switching = false
		elif attacking:
			current_sprite.play("shade-attack")
			await current_sprite.animation_finished
			attacking = false
		elif not is_on_floor():
			current_sprite.play("shade-jump")
		else:
			current_sprite.play("shade-walk")
	
	elif form == "SPIRIT":
		if switching:
			$Switch.play()
			current_sprite.play("spirit-switch-in")
			await current_sprite.animation_finished
			switching = false
		if not is_on_floor():
			current_sprite.play("spirit-jump")
		elif input_axis != 0:
			current_sprite.play("spirit-walk")
		else:
			current_sprite.play("spirit-idle")


func _on_charge_body_entered(body):
	if body == self:
		charges2 += 1


func _on_charge_2_body_entered(body):
	if body == self:
		charges2 += 1


func _on_level_one_tree_entered():
	spawning = true
	form = "SPECTER"
	jump_max = 2
	charges2 = 0
	shade = false
	spirit = false

func _on_level_two_tree_entered():
	spawning = true
	form = "SPECTER"
	jump_max = 2
	charges2 = 1
	shade = true
	spirit = false


func _on_level_three_tree_entered():
	spawning = true
	form = "SPECTER"
	jump_max = 2
	charges2 = 3
	shade = true
	spirit = false

func _on_level_four_tree_entered():
	spawning = true
	form = "SPECTER"
	jump_max = 2
	charges2 = 2
	shade = true
	spirit = false

func _on_level_five_tree_entered():
	spawning = true
	form = "SPECTER"
	jump_max = 2
	charges2 = 1
	shade = true
	spirit = true
