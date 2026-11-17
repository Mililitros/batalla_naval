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

{ #category : 'initialization' }
Nave >> initialize [
	super initialize.
	posiciones := OrderedCollection new.
	impactosRecibidos := Set new.
	recargaRestante := 0

]

{ #category : 'accessing' }
Nave >> tamano [ 
	^self subclassResponsibility
]
