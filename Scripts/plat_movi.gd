extends AnimatableBody2D

const WAIT_DURATION := 1.0

@export var move_speed := 3.0
@export var distance := 192
@export var move_horizontal := true
@export var inverso := true

var start_position : Vector2
var direction := 1

func _ready() -> void:
	# Como o script está na raiz, usamos a posição própria diretamente
	start_position = position
	move_plataform()

func move_plataform():
	if inverso != true:
		direction = -1
	
	var move_dir = Vector2.RIGHT * distance if move_horizontal else Vector2.UP * distance
	var duration = move_dir.length() / (move_speed * 64.0)

	var plataform_tween = create_tween().set_loops()
	# Sincroniza o Tween com o ciclo de física da Godot
	plataform_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)

	# Move a propriedade 'position' do próprio AnimatableBody2D
	plataform_tween.tween_property(
		self,
		"position",
		start_position + move_dir * direction,
		duration
	)

	plataform_tween.tween_interval(WAIT_DURATION)

	plataform_tween.tween_property(
		self,
		"position",
		start_position,
		duration
	)

	plataform_tween.tween_interval(WAIT_DURATION)
