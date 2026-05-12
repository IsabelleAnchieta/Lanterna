extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var speed: float = 150.0
@export var jump_velocity: float = -320.0
@export var gravity: float = 880.0

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	var direction = Input.get_axis("left", "right")
	
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	if is_on_floor():
		if direction != 0:
			$AnimatedSprite2D.flip_h = direction < 0
			$AnimatedSprite2D.play("walk")
		else:
			$AnimatedSprite2D.play("idle")

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		$AnimatedSprite2D.play("jump")

	move_and_slide()
