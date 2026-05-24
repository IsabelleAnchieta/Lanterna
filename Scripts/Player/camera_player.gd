extends Camera2D

@export var max_shake: float = 10.0
@export var shake_fade: float = 10.0

var shake_streath: float = 0.0

# Called when the node enters the scene tree for the first time.
func triggered_shake() -> void:
	shake_streath = max_shake


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shake_streath > 0:
		shake_streath = lerp(shake_streath, 0.0, shake_fade * delta)
		offset = Vector2(randf_range(-shake_streath, shake_streath), randf_range(-shake_streath, shake_streath))
