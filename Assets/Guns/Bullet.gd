extends RigidBody2D

func _on_Bullet_body_entered(body):
	if body.get_collision_layer_bit(global.boubbleCollisionLayer):
		body.hit()
	queue_free()
	pass
