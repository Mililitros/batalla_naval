"
Arma del Acorazado de largo alcance que impacta en patrón de cruz sobre la casilla elegida y sus cuatro adyacentes

"
Class {
	#name : 'CanionTurbo',
	#superclass : 'Arma',
	#category : 'BatallaNaval-Disparos',
	#package : 'BatallaNaval-Disparos'
}

{ #category : 'accessing' }
CanionTurbo >> alcance [
    ^ 15

]

{ #category : 'accessing' }
CanionTurbo >> cantidadDeObjetivos [
    ^ 1

]

{ #category : 'accessing' }
CanionTurbo >> coordenadasAfectadasPor: unasCoordenadas en: unTablero rival: unTerritorio [

    | centro |
    centro := unasCoordenadas first.
    ^ {
        centro.
        (Coordenada fila: centro fila - 1 columna: centro columna).
        (Coordenada fila: centro fila + 1 columna: centro columna).
        (Coordenada fila: centro fila columna: centro columna - 1).
        (Coordenada fila: centro fila columna: centro columna + 1) }
        select: [ :c | (unTablero coordenadaValida: c) and: [ unTerritorio incluye: c ] ]

]
