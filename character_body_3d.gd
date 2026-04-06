extends CharacterBody3D

# Al usar @export, estas variables aparecerán en el panel derecho (Inspector) 
# y podrás ajustarlas sin tener que abrir el código de nuevo.
@export var velocidad_caminar = 4.0
@export var velocidad_agachado = 1.5
@export var sensibilidad_raton = 0.001 # Hemos bajado drásticamente la sensibilidad

const JUMP_VELOCITY = 4.5
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Referencias a nuestros nodos
@onready var camera = $Camera3D
@onready var colision = $CollisionShape3D

# Variables para controlar el estado de agacharse
var esta_agachado = false
var altura_normal = 2.0
var altura_agachado = 1.0
var pos_camara_normal = 0.5
var pos_camara_agachado = 0.0

func _ready():
	# Atrapamos el ratón al iniciar
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	colision.shape.height = altura_normal

func _unhandled_input(event):
	# Rotación de la cámara
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensibilidad_raton)
		camera.rotate_x(-event.relative.y * sensibilidad_raton)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func _physics_process(delta):
	# Gravedad
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Salto (Puedes borrar este bloque de 'if' si no quieres que el personaje salte)
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# LÓGICA PARA AGACHARSE
	if Input.is_action_pressed("agacharse"):
		esta_agachado = true
		# Usamos lerp para encoger la colisión y bajar la cámara suavemente
		colision.shape.height = lerp(colision.shape.height, altura_agachado, delta * 10)
		camera.position.y = lerp(camera.position.y, pos_camara_agachado, delta * 10)
	else:
		esta_agachado = false
		# Volvemos a la altura normal suavemente
		colision.shape.height = lerp(colision.shape.height, altura_normal, delta * 10)
		camera.position.y = lerp(camera.position.y, pos_camara_normal, delta * 10)

	# Definimos la velocidad actual según la postura
	var velocidad_actual = velocidad_agachado if esta_agachado else velocidad_caminar

	# MOVIMIENTO
	# Usamos las nuevas acciones que creaste en el Mapa de Entrada
	var input_dir = Input.get_vector("izquierda", "derecha", "adelante", "atras")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * velocidad_actual
		velocity.z = direction.z * velocidad_actual
	else:
		velocity.x = move_toward(velocity.x, 0, velocidad_actual)
		velocity.z = move_toward(velocity.z, 0, velocidad_actual)

	move_and_slide()
