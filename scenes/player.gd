extends CharacterBody2D

# --- REFERÊNCIAS DA UI ---
@onready var health_bar = %HealthBar
@onready var sanity_bar = %SanityBar
@onready var game_over_screen = %GameOverScreen
@onready var luz = $Luz
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var speed: float = 150.0
@export var jump_velocity: float = -320.0
@export var gravity: float = 880.0

var vida: float = 100.0
var sanidade: float = 100.0
var energia_luz: float = 0.0
var pegou_primeira_tocha = false
var vivo = true

func _physics_process(delta):
	if not vivo: return
	# Se a posição Y for maior que o limite (ex: 1200), o player morre
	if global_position.y > 200: # <--- MUDE ESSE NÚMERO AQUI!
		morrer()
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

	for platforms in get_slide_collision_count():
		var collision = get_slide_collision(platforms)
		if collision.get_collider().has_method("has_collided_with"):
				collision.get_collider().has_collided_with(collision, self)
				
func _process(delta):
	if not vivo: return
	# 1. Lógica da Lanterna
	if energia_luz > 0:
		energia_luz -= delta * 0.02
		luz.energy = energia_luz
		# Recupera sanidade devagar se tiver luz
		sanidade = move_toward(sanidade, 100, delta * 2)
	else:
		energia_luz = 0
		luz.energy = 0
		# Perde sanidade no escuro
		sanidade -= 10.0 * delta # Perde 10 pontos por segundo
	
	# Não deixa passar de 100 nem ser menor que 0
	sanidade = clamp(sanidade, 0, 100)
	
	# ATUALIZA A BARRA
	# Se o Tween não estiver funcionando, use a linha abaixo para testar direto:
	sanity_bar.value = sanidade
	
	# Debug no terminal para ver os números descendo
	print("Sanidade atual: ", sanidade)

	# 2. Lógica da Vida (Dano se sanidade for 0)
	if sanidade <= 0:
		sanidade = 0
		vida -= delta * 15.0 # Perde 15 de vida por segundo
	
	# 3. Atualizar UI Suavemente
	atualizar_ui()

	# 4. Checar Morte
	if vida <= 0:
		morrer()

func atualizar_ui():
	# O Tween faz a barra "deslizar" suavemente
	var tween = create_tween().set_parallel(true)
	tween.tween_property(health_bar, "value", vida, 0.2)
	tween.tween_property(sanity_bar, "value", sanidade, 0.2)

func morrer():
	if not vivo: return # Evita chamar a função várias vezes
	
	vivo = false
	velocity = Vector2.ZERO
	# Desativa a colisão para ele parar de interagir com o mundo
	set_collision_layer_value(1, false)
	
	# Mostra o mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 
	
	game_over_screen.visible = true
	game_over_screen.modulate.a = 0
	var tween = create_tween() 
	tween.tween_property(game_over_screen, "modulate:a", 1.0, 1.5)


func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene() # Essa linha reinicia o jogo
