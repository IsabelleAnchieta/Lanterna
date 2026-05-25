extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var mat : ShaderMaterial

func setup(original_sprite: AnimatedSprite2D):
	sprite.sprite_frames = original_sprite.sprite_frames
	sprite.animation = original_sprite.animation
	sprite.frame = original_sprite.frame
	sprite.flip_h = original_sprite.flip_h
	sprite.flip_v = original_sprite.flip_v
	sprite.z_index = -1
	
	mat = sprite.material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("colorize_color", Color(0.855, 0.916, 1.0, 1.0))
		mat.set_shader_parameter("alpha", 0.6)
	
	position += Vector2(randi_range(-5, 5), randi_range(-50, -40))
	sprite.pause()
	fade_out()

func fade_out():
	var tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 0.0, 0.3).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(mat, "shader_parameter/alpha", 0.0, 0.3).set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(self.queue_free)
