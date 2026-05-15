extends CharacterBody2D

const SPEED = 900.0
const JUMP_VELOCITY = -400.0

var direction := 1
var vida := "vivo"

@onready var wall_detector := $walldet as RayCast2D
@onready var anim := $AnimatedSprite2D as AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if wall_detector.is_colliding():
		direction *= -1
		wall_detector.scale.x *= -1
		anim.flip_h = direction < 0
	
	velocity.x = direction * SPEED * delta
	
	if vida == "vivo":
		anim.play("idle")
		
	move_and_slide()


func _on_animated_sprite_2d_animation_finished():
	queue_free()



func _on_hitbox_body_entered(body: Node2D) -> void:
		direction *= -1
		wall_detector.scale.x *= -1
		anim.flip_h = direction < 0
