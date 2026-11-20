Class {
	#name : 'NaveTest',
	#superclass : 'TestCase',
	#instVars : [
		'crucero'
	],
	#category : 'BatallaNaval-Tests',
	#package : 'BatallaNaval-Tests'
}

{ #category : 'running' }
NaveTest >> setUp [
	super setUp.
	crucero := Crucero new.
	crucero posicionarEn: {
		Coordenada fila: 3 columna: 3.
		Coordenada fila: 3 columna: 4.
		Coordenada fila: 3 columna: 5 }

]

{ #category : 'tests' }
NaveTest >> testElDestructorDaTurnoExtraSoloSiAcierta [
    self assert: (Destructor new concedeTurnoExtraTras: { ResultadoImpacto new }).
    self deny: (Destructor new concedeTurnoExtraTras: { ResultadoAgua new }).
    self deny: (Crucero new concedeTurnoExtraTras: { ResultadoImpacto new })
]

{ #category : 'tests' }
NaveTest >> testElMismoImpactoNoSeCuentaDosVeces [
    crucero registrarImpactoEn: (Coordenada fila: 3 columna: 3).
    crucero registrarImpactoEn: (Coordenada fila: 3 columna: 3).
    self assert: crucero cantidadDeImpactos equals: 1
]

{ #category : 'tests' }
NaveTest >> testNoPuedeRecibirUnImpactoFueraDeSusPosiciones [
    self
        should: [ crucero registrarImpactoEn: (Coordenada fila: 9 columna: 9) ]
        raise: Error

]

{ #category : 'tests' }
NaveTest >> testNoSePuedePosicionarConUnaCantidadDeCoordenadasIncorrecta [
    self
        should: [ Crucero new posicionarEn: { Coordenada fila: 1 columna: 1 } ]
        raise: Error


]

{ #category : 'tests' }
NaveTest >> testOcupaSolamenteSusPosiciones [
    self assert: (crucero ocupa: (Coordenada fila: 3 columna: 4)).
    self deny: (crucero ocupa: (Coordenada fila: 9 columna: 9))

]

{ #category : 'tests' }
NaveTest >> testSeHundeCuandoTodasSusCasillasFueronImpactadas [
    | resultado |
    crucero registrarImpactoEn: (Coordenada fila: 3 columna: 3).
    crucero registrarImpactoEn: (Coordenada fila: 3 columna: 4).
    resultado := crucero registrarImpactoEn: (Coordenada fila: 3 columna: 5).
    self assert: resultado esHundido.
    self assert: crucero estaHundida.
    self deny: crucero estaOperativa
]

{ #category : 'tests' }
NaveTest >> testUnImpactoNoLaHunde [
    | resultado |
    resultado := crucero registrarImpactoEn: (Coordenada fila: 3 columna: 3).
    self assert: resultado esImpacto.
    self deny: resultado esHundido.
    self assert: crucero cantidadDeImpactos equals: 1.
    self assert: crucero estaOperativa
]
