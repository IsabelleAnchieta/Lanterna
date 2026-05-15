extends Area2D

#SUPER IMPORTANTE, VER QUANDO QUE ESTAMOS COLIDINDO

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		#owner.vida -= 10
		#owner.velocity.y = -220
		owner.semaforo = false
		if owner.ray_dir.is_colliding():
			owner.take_hit(Vector2(-300, -200))
		elif owner.ray_esq.is_colliding():
			owner.take_hit(Vector2(200, -200))
		elif owner.ray_cima.is_colliding():
			owner.take_hit(Vector2(-200, -200))
		else:
			owner.take_hit(Vector2(-200, -200))
		owner.anim.play("hit")
