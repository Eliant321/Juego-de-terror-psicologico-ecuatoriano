extends CSGBox3D

# Renombramos tu función "montar" a "interactuar" para que sea más universal,
# asegúrate de cambiar esto también en el script de tu Jugador (donde dice has_method)
func interactuar(jugador):
	if GameManager.cama_tendida == false:
		print("Tendido la cama...")
		GameManager.cama_tendida = true
		
		# Opcional: Aquí puedes cambiar el color del material del cubo para 
		# que el jugador vea que sí interactuó con éxito.
		
		# Revisamos si ya terminamos todo el tutorial
		GameManager.comprobar_tutorial()
	else:
		print("La cama ya está tendida.")
