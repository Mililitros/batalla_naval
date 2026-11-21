"
Representa un obstáculo de tierra firme en el tablero que impide ubicar naves encima y bloquea la trayectoria de los disparos

"
Class {
	#name : 'Isla',
	#superclass : 'Terreno',
	#category : 'BatallaNaval-Tablero',
	#package : 'BatallaNaval-Tablero'
}

{ #category : 'positioning' }
Isla >> alUbicarNave: unaNave en: unaCasilla [
    ^ self
]

{ #category : 'testing' }
Isla >> esIsla [
    ^ true
]

{ #category : 'testing' }
Isla >> permiteColocacion [
    ^ false
]
