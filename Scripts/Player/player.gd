extends CharacterBody2D

# --- REFERÊNCIAS DA UI ---
@onready var health_bar = %HealthBar
@onready var sanity_bar = %SanityBar
@onready var stamine_bar = %StamineBar
@onready var game_over_screen = %GameOverScreen
@onready var luz = $Luz
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim := $AnimatedSprite2D as AnimatedSprite2D
@onready var ray_dir := $ray_right as RayCast2D
@onready var ray_esq := $ray_left as RayCast2D
@onready var ray_cima := $ray_top as RayCast2D
@onready var efeito_sanidade = get_parent().get_node("CanvasLayer/ColorRect")
@onready var shader_material = efeito_sanidade.material
@onready var vinheta = get_parent().get_node("CanvasLayer/TextureRect")
@onready var VictoryScreen = get_parent().get_node("VictoryScreen/Label")
@onready var Labis = get_parent().get_node("VictoryScreen/ColorRect")

@export var ghost_trail : PackedScene
@export var speed: float = 150.0
@export var jump_velocity: float = -220.0
@export var gravity: float = 1000.0

var vida: float = 100.0
var sanidade: float = 100.0
var energia_luz: float = 0.0
var stamine: float = 100.0
var pegou_primeira_tocha = false
var vivo = true
var semaforo = true
var knockback_vector := Vector2.ZERO
var damage = 0
var roll = false
var ghost_timer : float = 0.0
var ghost_interval : float = 0.03

var state = "free"
var action_time = 0.0


func _ready():
	floor_constant_speed = true
	add_to_group("player")
	floor_snap_length = 10.0
	# Força o player a acumular a velocidade da plataforma ao pular dela
	platform_on_leave = PLATFORM_ON_LEAVE_ADD_VELOCITY
	
	if Global.checkpoint_scene == get_tree().current_scene.scene_file_path:
		var checkpoint = get_tree().current_scene.find_child(
			Global.checkpoint_name,
			true,
			false
		)
		if checkpoint:
			global_position = checkpoint.global_position
	
func _physics_process(delta):
	if not vivo: return
	# Se a posição Y for maior que o limite (ex: 1200), o player morre
	if global_position.y > 400: # <--- MUDE ESSE NÚMERO AQUI!
		morrer()
	if not is_on_floor():
		velocity.y += gravity * delta

	var direction = Input.get_axis("left", "right")
	
	#QUAL LADO ANDAR
	
	if semaforo == true:
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
#Se a gente quiser fazer chão escorregadinho
#			velocity.x = move_toward(velocity.x, 0, speed*delta)
	elif roll == false:
		velocity.x = 0;
	
	#ALTERNAR ENTRE ANDAR E FICAR PARADO
	if Input.is_action_just_pressed("roll") && is_on_floor() && roll == false && stamine >= 20:
		semaforo = false
		roll = true
		$AnimatedSprite2D.play("roll")
		$AnimationPlayer.play("roll")
		stamine -= 20
	
	if semaforo == true:
		if is_on_floor():

	#ANDANDO
			if direction != 0:
				$AnimatedSprite2D.scale.x = direction
				if energia_luz > 0:
					if $AnimatedSprite2D.animation != "walk_tocha":
						$AnimatedSprite2D.play("walk_tocha")
				else:
					if $AnimatedSprite2D.animation != "walk":
						$AnimatedSprite2D.play("walk")

	#PARADO
			else:

				if energia_luz > 0:
					if $AnimatedSprite2D.animation != "idle_tocha":
						$AnimatedSprite2D.play("idle_tocha")
				else:
					if $AnimatedSprite2D.animation != "idle":
						$AnimatedSprite2D.play("idle")
	#PULO			
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jump_velocity

			if energia_luz > 0:
				$AnimatedSprite2D.play("jump_tocha")
			else:
				$AnimatedSprite2D.play("jump")
		
		if Input.is_action_pressed("jump"):
			velocity.y -= 9
				
		if Input.is_action_just_pressed("down") and is_on_floor():
			set_collision_mask_value(2, false)
			await get_tree().create_timer(0.2).timeout
			set_collision_mask_value(2, true)

#CALCULO DA PANCADA

	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector

#PRA ATACAR

	if Input.is_action_just_pressed("atacar") && is_on_floor() && action_time > 0.0:
		damage = 2
		$AnimatedSprite2D.play("attack2")
		$AnimationPlayer.play("attack2")
	if Input.is_action_just_pressed("atacar") && is_on_floor() && semaforo == true && action_time <= 0.0:
		semaforo = false
		damage = 1
		$AnimatedSprite2D.play("attack")
		$AnimationPlayer.play("attack")
		action_time = 0.2


	move_and_slide()

	for platforms in get_slide_collision_count():
		var collision = get_slide_collision(platforms)
		if collision.get_collider().has_method("has_collided_with"):
				collision.get_collider().has_collided_with(collision, self)

func _process(delta):

	if roll == true:
		ghost_timer -= delta
		if ghost_timer <= 0:
			ghost_timer = ghost_interval
			spawn_ghost_trail() 

	#COMBO
	if action_time > 0.0:
		action_time -= 1.0 * delta
		
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

	vinheta.modulate.a = ((100.0 - sanidade) / 100.0) * 0.8
	efeito_sanidade.modulate.a = ((100.0 - sanidade) / 100.0) * 0.7

	if shader_material != null:
		shader_material.set_shader_parameter(
			"insanity",
			1.0 - (sanidade / 100.0)
		)
	
	# ATUALIZA A BARRA
	# Se o Tween não estiver funcionando, use a linha abaixo para testar direto:
	sanity_bar.value = sanidade
	
	stamine_bar.value = stamine
	
	# Debug no terminal para ver os números descendo
	#print("Sanidade atual: ", sanidade)

	# 2. Lógica da Vida (Dano se sanidade for 0)
	if sanidade <= 0:
		sanidade = 0
		vida -= delta * 15.0 # Perde 15 de vida por segundo
	
	# 3. Atualizar UI Suavemente
	atualizar_ui()

	# 4. Checar Morte
	if vida <= 0:
		$AnimatedSprite2D.play("death")
		morrer()
		
	stamine = move_toward(stamine, 100, delta * 5)

func atualizar_ui():
	# O Tween faz a barra "deslizar" suavemente
	var tween = create_tween().set_parallel(true)
	tween.tween_property(health_bar, "value", vida, 0.2)
	tween.tween_property(sanity_bar, "value", sanidade, 0.2)
	tween.tween_property(stamine_bar, "value", stamine, 0.2)

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

#NÃO FICAR PRESO EM ANIMAÇÕES DE PORRADA OU DE BATER

func _on_animated_sprite_2d_animation_finished() -> void:
	if !semaforo:
		semaforo = true
		roll = false

#LEVAR PORRADA E IR PRA TRÁS

func take_hit(knockback_force := Vector2.ZERO, duration := 0.25):
		
		if knockback_force != Vector2.ZERO:
			knockback_vector = knockback_force
			
			var knockback_tween := get_tree().create_tween()
			knockback_tween.tween_property(self, "knockback_vector", Vector2.ZERO, duration)
			
func camera_damage():
	$Camera.triggered_shake()
	
func spawn_ghost_trail():
	var ghost = ghost_trail.instantiate()
	ghost.global_position = global_position
	ghost.rotation = rotation
	ghost.scale = scale
	get_parent().add_child(ghost)
	ghost.setup($AnimatedSprite2D)
	
func concluir_fase():

	semaforo = false
	vivo = false
	
	$AnimatedSprite2D.play("idle")

	var camera = $Camera

	var tween = create_tween()

	tween.parallel().tween_property(
		camera,
		"zoom",
		Vector2(6,6),
		2.0
	)

	tween.parallel().tween_property(
		efeito_sanidade,
		"modulate:a",
		1.0,
		2.0
	)

	await tween.finished

	VictoryScreen.visible = true
