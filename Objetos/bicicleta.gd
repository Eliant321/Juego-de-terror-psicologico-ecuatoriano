extends CharacterBody3D

@export var velocidad_pedaleo = 10.0
@export var velocidad_giro = 2.0

# Variables para saber si estamos subidos en la bici
var esta_activa = false
var jugador_referencia = null # Aquí guardaremos al jugador cuando se suba
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var puede_desmontar = false

@onready var camara_bici = $Camera3D

func _physics_process(delta):
	# Gravedad
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Si la bici no está activa, solo aplicamos gravedad y detenemos el código aquí
	if not esta_activa:
		move_and_slide()
		return

	# --- LÓGICA DE MOVIMIENTO DE LA BICI ---
	var input_dir = Input.get_vector("izquierda", "derecha", "adelante", "atras")
	
	# Girar la bicicleta (Rotación en el eje Y)
	if input_dir.x != 0:
		rotate_y(-input_dir.x * velocidad_giro * delta)
	
	# Avanzar o retroceder (Aceleración en el eje Z local)
	# Usamos transform.basis.z para obtener el vector hacia donde mira la bici
	var direccion = (transform.basis * Vector3(0, 0, input_dir.y)).normalized()
	
	if direccion:
		velocity.x = direccion.x * velocidad_pedaleo
		velocity.z = direccion.z * velocidad_pedaleo
	else:
		# Fricción para frenar poco a poco
		velocity.x = move_toward(velocity.x, 0, velocidad_pedaleo * delta)
		velocity.z = move_toward(velocity.z, 0, velocidad_pedaleo * delta)

	move_and_slide()

	# --- LÓGICA PARA BAJARSE DE LA BICI ---
	if Input.is_action_just_pressed("interactuar") and puede_desmontar:
		desmontar()

# Función que llama el jugador cuando presiona 'E' mirando la bici
func montar(jugador):
	esta_activa = true
	puede_desmontar = false # Evita que te bajes enseguida
	jugador_referencia = jugador

	jugador.set_physics_process(false)
	jugador.hide()
	camara_bici.make_current()

	# Truco de Godot: Espera 0.5 segundos antes de permitir bajarte
	await get_tree().create_timer(0.5).timeout
	puede_desmontar = true

func desmontar():
	esta_activa = false
	
	# Movemos al jugador al lado de la bici para que no aparezca atascado dentro de ella
	# Le sumamos 1 metro en el eje Y para que caiga suavemente al suelo
	jugador_referencia.global_position = global_position + (transform.basis.x * 1.5) + Vector3(0, 1.0, 0)
	
	# Reactivamos al jugador
	jugador_referencia.set_physics_process(true)
	jugador_referencia.show()
	
	# Devolvemos la cámara al jugador
	jugador_referencia.get_node("Camera3D").make_current()
