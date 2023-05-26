extends KinematicBody2D

const GRAVITY = 10
const SPEED = 30
const FLOOR = Vector2(0, -1)

var velocity = Vector2()
var is_dead = false

var HP = 5

var direction = -1

# Adicione essas variáveis para controlar a troca de direção
var change_direction_timer
var change_direction_interval = 6.0

func _ready():
	change_direction_timer = Timer.new()
	change_direction_timer.wait_time = change_direction_interval
	change_direction_timer.connect("timeout", self, "_change_direction")
	add_child(change_direction_timer)
	change_direction_timer.start()
	pass 

func _change_direction():
	direction *= -1

func dead():
	is_dead = true
	velocity = Vector2(0,0)
	$AnimatedSprite.play("dead")
	$CollisionShape2D.call_deferred("set_disabled", true)
	$Area2D/CollisionShape.call_deferred("set_disabled", true)
	$Timer.start()

func hit():
	$TextureProgress.value -= 20
	HP -= 1
	if HP <= 0:
		dead()

func _physics_process(delta):
	if is_dead == false:
		velocity.x = SPEED * direction

		if direction == 1:
			$AnimatedSprite.flip_h = false
		else:
			$AnimatedSprite.flip_h = true

		$AnimatedSprite.play("default")

		velocity = move_and_slide(velocity, FLOOR)

	
func _on_Area2D_body_entered(body):
	if "KinematicBody2D" in body.name:
		body.hit()
	pass # Replace with function body.


func _on_Timer_timeout():
	queue_free()
	pass # Replace with function body.