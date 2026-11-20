"
Representa una embarcación abstracta de la flota. conoce las coordenadas que ocupa el tablero, los impactos recibidos y su tiempo de recarga. Colabora con Coordenada y Flota
"
Class {
	#name : 'Nave',
	#superclass : 'Object',
	#instVars : [
		'recargaRestante',
		'posiciones',
		'impactosRecibidos',
		'arma'
	],
	#category : 'BatallaNaval-Flota',
	#package : 'BatallaNaval-Flota'
}

{ #category : 'accessing' }
Nave >> arma [
    ^ arma

]

{ #category : 'accessing' }
Nave >> atacar: unasCoordenadas desde: unOrigen contra: unTablero rival: unTerritorio [

    | resultados |
    self puedeAtacar
        ifFalse: [ ^ NaveNoPuedeAtacar new signal: 'La nave no puede atacar en este momento' ].
    resultados := arma disparar: unasCoordenadas desde: unOrigen contra: unTablero rival: unTerritorio.
    recargaRestante := self turnosDeRecarga.
    ^ resultados

]

{ #category : 'accessing' }
Nave >> avanzarRecarga [
    recargaRestante > 0 ifTrue: [ recargaRestante := recargaRestante - 1 ]

]

{ #category : 'impacts' }
Nave >> cantidadDeImpactos [
    ^ impactosRecibidos size



]

{ #category : 'accessing' }
Nave >> concedeTurnoExtraTras: unosResultados [
    ^ false

]

{ #category : 'testing' }
Nave >> estaHundida [
    ^ impactosRecibidos size = self tamano




]

{ #category : 'testing' }
Nave >> estaInalcanzableDesde: unOrigen contra: unTablero rival: unTerritorio [
    ^ (self puedeAlcanzarAlgoDesde: unOrigen contra: unTerritorio) not
]

{ #category : 'testing' }
Nave >> estaOperativa [
    ^ self estaHundida not





]

{ #category : 'testing' }
Nave >> estaUbicada [
    ^ posiciones notEmpty
]

{ #category : 'initialization' }
Nave >> initialize [
	super initialize.
	posiciones := OrderedCollection new.
	impactosRecibidos := Set new.
	recargaRestante := 0

]

{ #category : 'positioning' }
Nave >> ocupa: unaCoordenada [
    ^ posiciones includes: unaCoordenada


]

{ #category : 'positioning' }
Nave >> posicionarEn: unasCoordenadas [
    unasCoordenadas size = self tamano
        ifFalse: [ ^ self error: 'La cantidad de coordenadas no coincide con el tamaño de la nave' ].
    posiciones := unasCoordenadas asOrderedCollection
]

{ #category : 'positioning' }
Nave >> posiciones [
    ^ posiciones


]

{ #category : 'testing' }
Nave >> puedeAlcanzarAlgoDesde: unOrigen contra: unTerritorio [
    ^ arma alcanzaAlgunaCasillaDe: unTerritorio desde: unOrigen
]

{ #category : 'accessing' }
Nave >> puedeAtacar [
    ^ self estaOperativa and: [ recargaRestante = 0 ]

]

{ #category : 'testing' }
Nave >> puedeReubicarseDesde: unOrigen contra: unTablero rival: unTerritorio [
    ^ self estaOperativa
        and: [ self cantidadDeImpactos = 0
            and: [ self estaInalcanzableDesde: unOrigen contra: unTablero rival: unTerritorio ] ]
]

{ #category : 'impacts' }
Nave >> puedeSerImpactada [ 
	^true
]

{ #category : 'accessing' }
Nave >> recargaRestante [
    ^ recargaRestante
]

{ #category : 'impacts' }
Nave >> registrarImpactoEn: unaCoordenada [

    (self ocupa: unaCoordenada)
        ifFalse: [ ^ self error: 'La nave no ocupa esa coordenada' ].
    impactosRecibidos add: unaCoordenada.
    ^ self estaHundida
        ifTrue: [ ResultadoHundido coordenada: unaCoordenada ]
        ifFalse: [ ResultadoImpacto coordenada: unaCoordenada ]





]

{ #category : 'accessing' }
Nave >> tamano [ 
	^self subclassResponsibility
]

{ #category : 'accessing' }
Nave >> turnosDeRecarga [
    ^ 0

]
