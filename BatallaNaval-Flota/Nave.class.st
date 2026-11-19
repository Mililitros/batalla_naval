"
Representa una embarcación abstracta de la flota. conoce las coordenadas que ocupa el tablero, los impactos recibidos y su tiempo de recarga. Colabora con Coordenada y Flota
"
Class {
	#name : 'Nave',
	#superclass : 'Object',
	#instVars : [
		'recargaRestante',
		'posiciones',
		'impactosRecibidos'
	],
	#category : 'BatallaNaval-Flota',
	#package : 'BatallaNaval-Flota'
}

{ #category : 'impacts' }
Nave >> cantidadDeImpactos [
    ^ impactosRecibidos size



]

{ #category : 'testing' }
Nave >> estaHundida [
    ^ impactosRecibidos size = self tamano




]

{ #category : 'testing' }
Nave >> estaOperativa [
    ^ self estaHundida not





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

{ #category : 'impacts' }
Nave >> puedeSerImpactada [ 
	^true
]

{ #category : 'impacts' }
Nave >> registrarImpactoEn: unaCoordenada [
    (self ocupa: unaCoordenada)
        ifFalse: [ ^ self error: 'La nave no ocupa esa coordenada' ].
    impactosRecibidos add: unaCoordenada.
    ^ self estaHundida
        ifTrue: [ ResultadoHundido new ]
        ifFalse: [ ResultadoImpacto new ]





]

{ #category : 'accessing' }
Nave >> tamano [ 
	^self subclassResponsibility
]
