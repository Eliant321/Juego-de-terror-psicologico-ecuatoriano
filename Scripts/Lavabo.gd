extends CSGBox3D

func interactuar(jugador):
	if GameManager.cara_lavada == false:
		print("Lavando la cara...")
		GameManager.cara_lavada = true
		GameManager.comprobar_tutorial()
	else:
		print("La cara ya está limpia.")
