extends Node

# ==========================================
# SEÑALES (Eventos Globales)
# ==========================================
# Las señales son útiles para que la interfaz (UI) o el mapa se enteren 
# de que algo cambió sin tener que preguntar todo el tiempo.
signal tutorial_completado
signal estado_historia_cambiado(nuevo_estado)

# ==========================================
# ESTADOS DE LA HISTORIA
# ==========================================
# Usamos un Enum para saber exactamente en qué parte del Capítulo 1 estamos.
enum EstadoJuego {
	TUTORIAL,       # En el cuarto de María
	CASA_MAMA,      # Bajando a comer y recibiendo el encargo
	CALLE_MERCADO,  # Camino al mercado / Encuentro con amigas
	CEMENTERIO,     # Robando los objetos
	CASA_NOCHE,     # Las 3:00 AM / Persecución
	FIN_CAPITULO
}

var estado_actual: EstadoJuego = EstadoJuego.TUTORIAL

# ==========================================
# VARIABLES DEL TUTORIAL
# ==========================================
var se_levanto: bool = false # Para el inicio [cite: 7]
var cama_tendida: bool = false # [cite: 8]
var cara_lavada: bool = false # [cite: 10]

# ==========================================
# INVENTARIO Y DINERO
# ==========================================
var tiene_dinero: bool = false
var tiene_tripa_mishqui: bool = false

# Diccionario para los objetos clave del cementerio [cite: 88]
var inventario_cementerio = {
	"pala": false,     # [cite: 89]
	"linterna": false, # [cite: 91]
	"sierra": false    # [cite: 92]
}

# ==========================================
# VARIABLES DE DECISIONES (RAMIFICACIONES)
# ==========================================
# Estas variables recordarán lo que hizo el jugador para cambiar el futuro
var jugo_con_amigas: bool = false # Si eligió jugar [cite: 39]
var fue_robada: bool = false      # Si eligió ir al mercado y le robaron [cite: 40, 67]

# ==========================================
# FUNCIONES DE LÓGICA GLOBAL
# ==========================================

# Esta función la llamaremos desde la cama o el lavabo cuando interactuemos
func comprobar_tutorial():
	if se_levanto and cama_tendida and cara_lavada:
		avanzar_historia(EstadoJuego.CASA_MAMA)
		tutorial_completado.emit()
		print("Tutorial completado. ¡Se escucha el grito de la mamá!") # [cite: 12, 13]

# Función para cambiar de fase y avisarle al resto del juego
func avanzar_historia(nuevo_estado: EstadoJuego):
	estado_actual = nuevo_estado
	estado_historia_cambiado.emit(estado_actual)
	print("El estado de la historia cambió a: ", estado_actual)
