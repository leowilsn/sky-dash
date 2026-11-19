extends Node2D

const PIPE_SCENE: PackedScene = preload("res://scenes/pipe_pair.tscn")

var score: int = 0
var pipe_speed: float = 100.0
var gap: float = 90.0
var over: bool = false

@onready var score_label: Label = $HUD/ScoreLabel

var started: bool = false

func _ready() -> void:
	$Bird.freeze = true   # the bird waits in the air
	var pulse: Tween = create_tween().set_loops()
	pulse.tween_property($HUD/TapLabel, "modulate:a", 0.4, 0.5)
	pulse.tween_property($HUD/TapLabel, "modulate:a", 1.0, 0.5)

func _physics_process(_delta: float) -> void:
	if not started and Input.is_action_just_pressed("flap"):
		started = true
		$Bird.freeze = false
		$PipeTimer.start()
		$HUD/TapLabel.visible = false

func _on_pipe_timer_timeout() -> void:
	var pipe = PIPE_SCENE.instantiate()
	pipe.position = Vector2(520, randf_range(80, 190))
	pipe.speed = pipe_speed
	pipe.gap = gap
	add_child(pipe)

func add_point() -> void:
	score += 1
	score_label.text = str(score)
	score_label.pivot_offset = score_label.size / 2   # grow from the middle
	score_label.scale = Vector2(1.3, 1.3)
	var pop: Tween = create_tween()
	pop.tween_property(score_label, "scale", Vector2.ONE, 0.15)
	if score % 5 == 0:   # every 5 pipes
		pipe_speed += 15.0
		gap = max(gap - 4.0, 70.0)   # smaller gap, but never below 70
		$GroundLayer.autoscroll.x = -pipe_speed
		for pipe in get_tree().get_nodes_in_group("pipes"):
			pipe.speed = pipe_speed
	$PointSound.play()
	$Bird/Sparkle.restart()

func game_over() -> void:
	if over:
		return
	over = true
	$CrashSound.play()
	$PipeTimer.stop()
	$Bird.set_deferred("freeze", true)   # the bird stops falling
	for pipe in get_tree().get_nodes_in_group("pipes"):
		pipe.speed = 0.0
	$GroundLayer.autoscroll.x = 0.0   # the ground stops with the pipes
	$Camera2D.shake()
	var record: bool = Save.submit(score)
	$HUD/GameOverPanel/ScoreText.text = "Score: %d" % score
	$HUD/GameOverPanel/BestText.text = "Best: %d" % Save.best
	$HUD/GameOverPanel.visible = true
	if record:
		var label: Label = $HUD/GameOverPanel/RecordLabel
		label.visible = true
		var tween: Tween = create_tween().set_loops()   # flash forever
		tween.tween_property(label, "modulate:a", 0.2, 0.25)
		tween.tween_property(label, "modulate:a", 1.0, 0.25)

func _on_retry_button_pressed() -> void:
	Fade.change_scene("res://scenes/game.tscn")

func _on_menu_button_pressed() -> void:
	Fade.change_scene("res://scenes/main_menu.tscn")
