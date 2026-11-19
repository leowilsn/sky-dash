extends Node2D

var speed: float = 100.0
var gap: float = 90.0

func _ready() -> void:
	add_to_group("pipes")
	$Top.position.y = -gap / 2
	$Bottom.position.y = gap / 2

func _process(delta: float) -> void:
	position.x -= speed * delta

func _on_pipe_body_entered(body: Node2D) -> void:
	if body.has_method("die"):
		body.die()

func _on_score_zone_body_entered(body: Node2D) -> void:
	if body.has_method("die"):
		get_tree().current_scene.add_point()
		$ScoreZone.set_deferred("monitoring", false)   # count each pipe once

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
