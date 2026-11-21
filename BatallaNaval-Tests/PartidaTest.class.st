Class {
	#name : 'PartidaTest',
	#superclass : 'TestCase',
	#instVars : [
		'partida'
	],
	#category : 'BatallaNaval-Tests',
	#package : 'BatallaNaval-Tests'
}

{ #category : 'running' }
PartidaTest >> setUp [
    super setUp.
    partida := Partida contraLaIA: 'Test' azar: (Random seed: 5)
]

{ #category : 'tests' }
PartidaTest >> testArrancaColocandoMinasConIslasEnAmbosCampos [
    self assert: partida estado equals: #colocandoMinas.
    self assert: ((partida tablero cantidadDeIslasEn: Territorio superior) between: 2 and: 3).
    self assert: ((partida tablero cantidadDeIslasEn: Territorio inferior) between: 2 and: 3)

]

{ #category : 'tests' }
PartidaTest >> testElLimiteDeTurnosFinalizaLaPartida [
    | simulada |
    simulada := Partida entreIAs: (Random seed: 2).
    simulada turnosMaximosPorJugador: 1.
    1 to: 20 do: [ :paso |
        simulada estaFinalizada ifFalse: [ simulada jugadorActual jugarTurno: simulada ] ].
    self assert: simulada estaFinalizada.
    self assert: simulada turnosJugados equals: 2
]

{ #category : 'tests' }
PartidaTest >> testLaIAColocaSusMinasEnElCampoDelJugador [
    self assert: (partida tablero cantidadDeMinasEn: Territorio inferior) <= 3.
    self assert: (partida tablero cantidadDeMinasEn: Territorio superior) equals: 0

]

{ #category : 'tests' }
PartidaTest >> testNoSePuedeAtacarAntesDeEmpezar [
    self should: [ partida atacarCon: nil objetivos: #() ] raise: AccionFueraDeTurno


]

{ #category : 'tests' }
PartidaTest >> testNoSePuedenColocarMinasEnElPropioCampo [
    self
        should: [ partida ubicarMinaEn: (Coordenada fila: 20 columna: 3) ]
        raise: UbicacionInvalida

]

{ #category : 'tests' }
PartidaTest >> testTresMinasPasanALaFaseDeNaves [
    1 to: 3 do: [ :i | partida ubicarMinaEn: (Coordenada fila: 1 columna: i) ].
    self assert: partida estado equals: #colocandoNaves


]

{ #category : 'tests' }
PartidaTest >> testUnaPartidaEntreIAsSiempreTermina [
    1 to: 20 do: [ :semilla |
        | simulada pasos |
        simulada := Partida entreIAs: (Random seed: semilla).
        pasos := 0.
        [ simulada estaFinalizada or: [ pasos > 500 ] ] whileFalse: [
            simulada jugadorActual jugarTurno: simulada.
            pasos := pasos + 1 ].
        self assert: simulada estaFinalizada.
        self assert: (simulada hayGanador or: [ simulada esEmpate ]) ]
]
