"
Representa una celda individual dentro del tablero, conoce su ubicación, el terreno que contiene y si ya fue atacada
"
Class {
	#name : 'Casilla',
	#superclass : 'Object',
	#instVars : [
		'coordenada',
		'terreno',
		'nave',
		'atacada'
	],
	#category : 'BatallaNaval-Tablero',
	#package : 'BatallaNaval-Tablero'
}

{ #category : 'instance creation' }
Casilla class >> coordenada: unaCoordenada [
	^self new setCoordenada: unaCoordenada 
	
]

{ #category : 'initialization' }
Casilla >> coordenada [ 
	^coordenada 
]

{ #category : 'initialization' }
Casilla >> estaAtacada [
	^atacada
	
]

{ #category : 'initialization' }
Casilla >> estaOcupada [ 
	^nave notNil 
	
]

{ #category : 'initialization' }
Casilla >> initialize [
	super initialize.
	terreno:= Agua new.
	atacada:= false
	
]

{ #category : 'initialization' }
Casilla >> nave [
	^nave
	
]

{ #category : 'initialization' }
Casilla >> ocuparCon: unaNave [
	self estaOcupada 
		ifTrue: [ ^UbicacionInvalida new signal: 'La casilla ya está ocupada' ].
	nave:= unaNave.
	terreno alUbicarNave: unaNave en: self
	
	
]

{ #category : 'initialization' }
Casilla >> recibirDisparo [
    atacada ifTrue: [ ^ CasillaYaAtacada new signal: 'Esa casilla ya fue atacada' ].
    (nave notNil and: [ nave puedeSerImpactada not ])
        ifTrue: [ ^ ResultadoAgua new ].
    atacada := true.
    ^ nave isNil
        ifTrue: [ ResultadoAgua new ]
        ifFalse: [ nave registrarImpactoEn: coordenada ]
	
	
]

{ #category : 'initialization' }
Casilla >> setCoordenada: unaCoordenada [
	coordenada:= unaCoordenada 
]

{ #category : 'initialization' }
Casilla >> terreno [ 
	^terreno 
]

{ #category : 'initialization' }
Casilla >> tieneMina [
	^terreno esCampoMinado 
	
]

{ #category : 'initialization' }
Casilla >> ubicarMina [
	terreno:= CampoMinado new
	
]
