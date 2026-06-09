extends Camera2D

@export var max_shake := 10.0
@export var shake_fade := 10.0

var shake_strength := 0.0

var offset_alvo := Vector2.ZERO
var look_ahead_offset := Vector2.ZERO
var shake_offset := Vector2.ZERO

var zoom_alvo := Vector2(2.0, 2.0)

func triggered_shake():
	shake_strength = max_shake

func _process(delta):

	# ZOOM
	if abs(owner.velocity.x) > 100:
		zoom_alvo = Vector2(1.8, 1.8)
	else:
		zoom_alvo = Vector2(2.0, 2.0)

	zoom = zoom.lerp(zoom_alvo, delta * 3)

	# LOOK AHEAD
	if owner.velocity.x > 0:
		offset_alvo.x = 100
	elif owner.velocity.x < 0:
		offset_alvo.x = -100
	else:
		offset_alvo.x = 0

	look_ahead_offset = look_ahead_offset.lerp(
		offset_alvo,
		delta * 4
	)

	# SHAKE
	if shake_strength > 0:
		shake_strength = lerp(
			shake_strength,
			0.0,
			shake_fade * delta
		)

		shake_offset = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)
	else:
		shake_offset = Vector2.ZERO

	# RESULTADO FINAL
	offset = look_ahead_offset + shake_offset
