extends Camera2D

var shake_time: float = 0.0
var strength: float = 4.0   # pixels

func shake(duration: float = 0.3) -> void:
	shake_time = duration
	
func _process(delta: float) -> void:
	if shake_time > 0:
		shake_time -= delta
		offset = Vector2(randf_range(-strength, strength), randf_range(-strength, strength))
	else:
		offset = Vector2.ZERO
