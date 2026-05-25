extends Area2D
var player_perto = null
@onready var sprite = $AnimatedSprite2D
@onready var hint = get_tree().current_scene.get_node("UI/Dicas/HintLabel")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play("acesa")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if player_perto != null:
		if Input.is_action_just_pressed("pegar_tocha"):
			var player = player_perto
			if player == null:
				return

			# liga luz do player
			player.energia_luz = 1.42
			player.luz.energy = 1.42
			player.pegou_primeira_tocha = true
			hint.visible = false
			queue_free()
			print("PEGOU TOCHA")
			


func _on_body_entered(body: Node2D) -> void:
	
	if body.name == "Player":
		player_perto = body
		if not body.pegou_primeira_tocha:
			hint.visible = true


func _on_body_exited(body: Node2D) -> void:
	if body == player_perto:
		player_perto = null
		hint.visible = false
