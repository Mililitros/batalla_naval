Class {
	#name : 'Partida',
	#superclass : 'Object',
	#instVars : [
		'tablero',
		'jugadores',
		'jugadorActual',
		'estado',
		'turnoExtraEnCurso',
		'turnosJugados',
		'turnosMaximosPorJugador',
		'azar'
	],
	#category : 'BatallaNaval-Partida',
	#package : 'BatallaNaval-Partida'
}

{ #category : 'as yet unclassified' }
Partida class >> contraLaIA: unNombre azar: unRandom [
    ^ self jugadores: {
        Jugador nombre: unNombre territorio: Territorio inferior.
        JugadorIA nombre: 'Computadora' territorio: Territorio superior azar: unRandom }
        azar: unRandom
]

{ #category : 'instance creation' }
Partida class >> entreIAs: unRandom [
    ^ self jugadores: {
        JugadorIA nombre: 'IA 1' territorio: Territorio inferior azar: unRandom.
        JugadorIA nombre: 'IA 2' territorio: Territorio superior azar: unRandom }
        azar: unRandom
]

{ #category : 'instance creation' }
Partida class >> jugadores: unosJugadores azar: unRandom [
    ^ self new setJugadores: unosJugadores azar: unRandom; iniciar; yourself
]
