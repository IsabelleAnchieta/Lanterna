extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.checkpoint_scene = get_tree().current_scene.scene_file_path
		Global.checkpoint_name = name
