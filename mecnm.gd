extends KinematicBody2D


var vel = Vector2()
export var speed = 3000
export var grav = 300
export var jumpi = 50
var ploded = false
var ploding = false
var crok = false
var wid

func _ready():
	wid = $CollisionShape2D.get_shape().get_extents().x / 2
	print(wid)

func _physics_process(delta):	

	crok = Input.is_action_pressed("ui_down")

	if $AnimationPlayer.current_animation != "explode":



		if Input.is_action_just_pressed("ui_up"):
			jump()

		if Input.is_action_just_pressed("ui_accept"):
			if not ploded:
				$AnimationPlayer.play("explode")
				yield($AnimationPlayer,"animation_finished")
				#$AnimationPlayer.stop(false)
				hide()
				
				ploded = true
			else:
				$AnimationPlayer.play_backwards("explode")
				show()
				yield($AnimationPlayer,"animation_finished")
				ploded = false

		elif Input.is_action_pressed("ui_right"):
			walk(speed * delta)
			if not (crok or ploded):
				$AnimationPlayer.play("walk")

		elif Input.is_action_pressed("ui_left"):
			walk(-speed * delta)
			if not (crok or ploded):
				$AnimationPlayer.play("walk")

		else:
			vel.x = 0
			if not ploded:
				$AnimationPlayer.play("idle")
			
		if crok:
			$AnimationPlayer.play("cro")

	
	vel.y += grav * delta
	vel = move_and_slide(vel, Vector2.UP)


	if position.x > get_viewport_rect().size.x + wid:
		set_position(Vector2(-wid,position.y))
	elif position.x < -wid:
		set_position(Vector2(get_viewport_rect().size.x + wid,position.y))
		
		

func jump():
	vel.y -= jumpi


func walk(fastness):
	vel.x = fastness
	$mimi.set("flip_h",fastness < 0)
