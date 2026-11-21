"
Representa una posición específica (fila y columna) dentro del tablero del juego
"
Class {
	#name : 'Coordenada',
	#superclass : 'Object',
	#instVars : [
		'fila',
		'columna'
	],
	#category : 'BatallaNaval-Tablero',
	#package : 'BatallaNaval-Tablero'
}

{ #category : 'instance creation' }
Coordenada class >> desdeTexto: unTexto [

    | texto columna fila |
    texto := unTexto trimBoth asUppercase.
    texto size < 2
        ifTrue: [ ^ EntradaInvalida new signal: 'Escribí una letra y un número, por ejemplo H8' ].
    columna := texto first asciiValue - 64.
    fila := texto allButFirst asInteger.
    (texto first isLetter and: [ fila notNil ])
        ifFalse: [ ^ EntradaInvalida new signal: 'Escribí una letra y un número, por ejemplo H8' ].
    ^ self fila: fila columna: columna

]

{ #category : 'instance creation' }
Coordenada class >> fila: unaFila columna: unaColumna [
	^ self new setFila: unaFila columna: unaColumna

]

{ #category : 'comparing' }
Coordenada >> = otraCoordenada [
	^ self class = otraCoordenada class
		and: [ fila = otraCoordenada fila and: [ columna = otraCoordenada columna ] ]

]

{ #category : 'accessing' }
Coordenada >> columna [
	^columna
]

{ #category : 'printing' }
Coordenada >> comoTexto [
	^ (Character value: 64 + columna) asString , fila printString

]

{ #category : 'accessing' }
Coordenada >> fila [ 
	^fila 
]

{ #category : 'comparing' }
Coordenada >> hash [
	^ fila hash bitXor: columna hash

]

{ #category : 'printing' }
Coordenada >> printOn: unStream [
	unStream nextPutAll: self comoTexto

]

{ #category : 'initialization' }
Coordenada >> setFila: unaFila columna: unaColumna [
	fila := unaFila.
	columna := unaColumna

]
