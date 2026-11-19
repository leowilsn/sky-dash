extends RigidBody2D

@export var flap_strength: float = 250.0
@export var max_fall_speed: float = 300.0

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("flap") and not dead:
		linear_velocity.y = 0.0   # forget the fall, so every flap feels the same
		apply_impulse(Vector2(0, -flap_strength))   # a kick upwards
		$FlapSound.pitch_scale = randf_range(0.9, 1.1)   # never exactly the same
		$FlapSound.play()
	if position.y > 240:   # touched the ground
		die()

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	# never fall faster than max_fall_speed
	if state.linear_velocity.y > max_fall_speed:
		state.linear_velocity.y = max_fall_speed

var dead: bool = false

func die() -> void:
	if dead:
		return
	dead = true
	$AnimatedSprite2D.visible = false   # the bird "explodes"
	$FeatherBurst.emitting = true
	get_tree().current_scene.game_over()
