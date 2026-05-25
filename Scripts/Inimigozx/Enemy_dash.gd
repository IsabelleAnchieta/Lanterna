extends CharacterBody2D

const JUMP_VELOCITY = -300.0

@export var SPEED = 2200.0
@export var vida := 5
@export var direction := 1
@export var damage = 30

var walk = true
var posi = 0.0
var semaforo = true
var timer = 1.0
var timer2 = 1.0
var wait = true


@onready var wall_detector := $walldet as RayCast2D
@onready var anim := $AnimatedSprite2D as AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if wall_detector.is_colliding():
		direction *= -1
		wall_detector.scale.x *= direction
		anim.flip_h = direction < 0

func _process(delta):

	if semaforo == true:
		if walk == true && wait == true:
			velocity.x = direction * SPEED * delta * 2
		else:
			if velocity.x > 0:
				velocity.x -= 5
			elif velocity.x < 0:
				velocity.x += 5
			else:
				velocity.x = 0
	else:
		take_hit(posi)

	if !walk:
		timer -= 1.0 * delta
	else:
		timer = 1.0

	if timer <= 0:
		walk = true
		
	if !wait:
		timer2 -= 1.0 * delta
	else:
		timer2 = 6.0
		
	if timer2 <= 0:
		wait = true

	if vida > 0:
		anim.play("idle")

	move_and_slide()

func _on_animated_sprite_2d_animation_finished():
	queue_free()
	

func _on_hitbox_body_entered(body: Node2D) -> void:
		direction *= -1
		wait = false
		
func take_hit(posi := 0.0):
	var dist = posi - position.x
	
	if dist > 0:
		velocity.x = -200
	else:
		velocity.x = 200
	velocity.y = -200
	
	semaforo = true
