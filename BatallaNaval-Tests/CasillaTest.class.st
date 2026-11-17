Class {
	#name : 'CasillaTest',
	#superclass : 'TestCase',
	#instVars : [
		'casilla',
		'coordenada',
		'crucero'
	],
	#category : 'BatallaNaval-Tests',
	#package : 'BatallaNaval-Tests'
}

{ #category : 'running' }
CasillaTest >> setUp [
    super setUp.
    coordenada := Coordenada fila: 3 columna: 4.
    casilla := Casilla coordenada: coordenada.
    crucero := Crucero new.
    crucero posicionarEn: {
        Coordenada fila: 3 columna: 3.
        coordenada.
        Coordenada fila: 3 columna: 5 }
]

{ #category : 'tests' }
CasillaTest >> testDisparoAUnaCasillaVaciaEsAgua [
    | resultado |
    resultado := casilla recibirDisparo.
    self deny: resultado esImpacto.
    self assert: casilla estaAtacada
]

{ #category : 'tests' }
CasillaTest >> testDisparoAUnaNaveEsImpacto [
    | resultado |
    casilla ocuparCon: crucero.
    resultado := casilla recibirDisparo.
    self assert: resultado esImpacto.
    self assert: crucero cantidadDeImpactos equals: 1
]

{ #category : 'tests' }
CasillaTest >> testNoSePuedeDispararDosVecesALaMismaCasilla [
    casilla recibirDisparo.
    self should: [ casilla recibirDisparo ] raise: CasillaYaAtacada
]

{ #category : 'tests' }
CasillaTest >> testNoSePuedeOcuparUnaCasillaOcupada [
    casilla ocuparCon: crucero.
    self should: [ casilla ocuparCon: Destructor new ] raise: UbicacionInvalida
]

{ #category : 'tests' }
CasillaTest >> testSePuedeOcuparConUnaNave [
    casilla ocuparCon: crucero.
    self assert: casilla estaOcupada.
    self assert: casilla nave equals: crucero
]

{ #category : 'tests' }
CasillaTest >> testUnSubmarinoSumergidoNoRecibeImpacto [
    | submarino resultado |
    submarino := Submarino new.
    submarino posicionarEn: {
        coordenada.
        Coordenada fila: 3 columna: 5.
        Coordenada fila: 3 columna: 6 }.
    casilla ocuparCon: submarino.
    resultado := casilla recibirDisparo.
    self deny: resultado esImpacto.
    self deny: casilla estaAtacada.
    self assert: submarino cantidadDeImpactos equals: 0
]

{ #category : 'tests' }
CasillaTest >> testUnaCasillaNuevaEstaLibreSinAtacarYSinMina [
    self deny: casilla estaOcupada.
    self deny: casilla estaAtacada.
    self deny: casilla tieneMina
]

{ #category : 'tests' }
CasillaTest >> testUnaMinaExplotaAlUbicarUnaNave [
    casilla ubicarMina.
    self assert: casilla tieneMina.
    casilla ocuparCon: crucero.
    self assert: crucero cantidadDeImpactos equals: 1.
    self assert: casilla estaAtacada

]

{ #category : 'tests' }
CasillaTest >> testUnaMinaNoDañaAUnSubmarinoSumergido [
    | submarino |
    submarino := Submarino new.
    submarino posicionarEn: {
        coordenada.
        Coordenada fila: 3 columna: 5.
        Coordenada fila: 3 columna: 6 }.
    casilla ubicarMina.
    casilla ocuparCon: submarino.
    self assert: submarino cantidadDeImpactos equals: 0
]
