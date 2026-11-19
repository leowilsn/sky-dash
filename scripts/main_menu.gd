extends Control

func _ready() -> void:
	$BestLabel.text = "Best: %d" % Save.best
	$Title.position.y = -60
	var t1: Tween = create_tween()
	t1.tween_property($Title, "position:y", 50.0, 0.6).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	$PlayButton.position.y = 300
	var t2: Tween = create_tween()
	t2.tween_property($PlayButton, "position:y", 150.0, 0.5).set_delay(0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	$PlayButton.grab_focus()

func _on_play_button_pressed() -> void:
	Fade.change_scene("res://scenes/game.tscn")
