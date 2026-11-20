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
		'atacada',
		'revelada'
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
Casilla >> estaRevelada [
    ^ revelada
]

{ #category : 'initialization' }
Casilla >> initialize [
    super initialize.
    terreno := Agua new.
    atacada := false.
    revelada := false
]

{ #category : 'initialization' }
Casilla >> liberar [
    nave := nil
]

{ #category : 'initialization' }
Casilla >> nave [
	^nave
	
]

{ #category : 'initialization' }
Casilla >> ocuparCon: unaNave [
    self permiteColocacion
        ifFalse: [ ^ UbicacionInvalida new signal: 'No se puede ubicar una nave en ', coordenada comoTexto ].
    nave := unaNave.
    terreno alUbicarNave: unaNave en: self
]

{ #category : 'initialization' }
Casilla >> permiteColocacion [
    ^ terreno permiteColocacion and: [ self estaOcupada not ]
]

{ #category : 'initialization' }
Casilla >> puedeRecibirDisparo [
    ^ terreno esIsla or: [ atacada not ]
]

{ #category : 'initialization' }
Casilla >> recibirBombardeo [
    terreno esIsla ifTrue: [ ^ ResultadoAgua new ].
    ^ self recibirDisparo

]

{ #category : 'initialization' }
Casilla >> recibirDisparo [
    terreno esIsla ifTrue: [ revelada := true. ^ ResultadoBloqueado new ].
    atacada ifTrue: [ ^ CasillaYaAtacada new signal: 'Esa casilla ya fue atacada' ].
    (nave notNil and: [ nave puedeSerImpactada not ])
        ifTrue: [ ^ ResultadoAgua new ].
    atacada := true.
    revelada := true.
    ^ nave isNil
        ifTrue: [ ResultadoAgua new ]
        ifFalse: [ nave registrarImpactoEn: coordenada ]
]

{ #category : 'initialization' }
Casilla >> setCoordenada: unaCoordenada [
	coordenada:= unaCoordenada 
]

{ #category : 'initialization' }
Casilla >> simboloCompleto [
    terreno esIsla ifTrue: [ ^ #isla ].
    nave isNil ifTrue: [ ^ atacada ifTrue: [ #agua ] ifFalse: [ #libre ] ].
    nave estaHundida ifTrue: [ ^ #hundida ].
    ^ atacada ifTrue: [ #impacto ] ifFalse: [ #nave ]
]

{ #category : 'initialization' }
Casilla >> simboloOculto [
    ^ revelada ifTrue: [ self simboloCompleto ] ifFalse: [ #oculta ]
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
Casilla >> ubicarIsla [
    terreno := Isla new
]

{ #category : 'initialization' }
Casilla >> ubicarMina [
    self estaOcupada
        ifTrue: [ ^ UbicacionInvalida new signal: 'La casilla está ocupada' ].
    terreno esIsla ifTrue: [ revelada := true. ^ self ].
    terreno esCampoMinado
        ifTrue: [ ^ UbicacionInvalida new signal: 'Ya hay una mina en ', coordenada comoTexto ].
    terreno := CampoMinado new
]
