"
Agrupa y administra el conjunto de naves de un jugador, y permite verificar el estado general de los barcos y determinar si toda la flota fue hundida
"
Class {
	#name : 'Flota',
	#superclass : 'Object',
	#instVars : [
		'naves'
	],
	#category : 'BatallaNaval-Flota',
	#package : 'BatallaNaval-Flota'
}

{ #category : 'instance creation' }
Flota class >> estandar [ 
	|flota|
	flota := self new.
	 2 timesRepeat: [ flota agregarNave: Portaaviones new ].
    2 timesRepeat: [ flota agregarNave: Acorazado new ].
    2 timesRepeat: [ flota agregarNave: Crucero new ].
    1 timesRepeat: [ flota agregarNave: Submarino new ].
    3 timesRepeat: [ flota agregarNave: Destructor new ].
    ^ flota
]

{ #category : 'accessing' }
Flota >> agregarNave: unaNave [
	naves add: unaNave
]

{ #category : 'testing' }
Flota >> avanzarRecargas [
    naves do: [ :cadaNave | cadaNave avanzarRecarga ]

]

{ #category : 'accessing' }
Flota >> cantidadDeNaves [
	^naves size
]

{ #category : 'accessing' }
Flota >> cantidadDeNavesHundidas [
    ^ (naves select: [ :cadaNave | cadaNave estaHundida ]) size
]

{ #category : 'initialization' }
Flota >> initialize [ 
	super initialize.
	naves := OrderedCollection new
]

{ #category : 'accessing' }
Flota >> naves [
    ^ naves
]

{ #category : 'accessing' }
Flota >> navesOperativas [
    ^ naves select: [ :cadaNave | cadaNave estaOperativa ]
]

{ #category : 'accessing' }
Flota >> navesQuePuedenAtacar [
    ^ naves select: [ :cadaNave | cadaNave puedeAtacar ]

]

{ #category : 'testing' }
Flota >> todasHundidas [
    ^ naves allSatisfy: [ :cadaNave | cadaNave estaHundida ]
]
