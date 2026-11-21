"
Define las filas que pertenecen a un bando y calcula la dirección de ataque y el origen de disparo de sus naves

"
Class {
	#name : 'Territorio',
	#superclass : 'Object',
	#instVars : [
		'filaInicial',
		'filaFinal',
		'direccionAlRival'
	],
	#category : 'BatallaNaval-Tablero',
	#package : 'BatallaNaval-Tablero'
}

{ #category : 'as yet unclassified' }
Territorio class >> filas: desde hasta: hasta direccionAlRival: unaDireccion [
    ^ self new setDesde: desde hasta: hasta direccion: unaDireccion
]

{ #category : 'as yet unclassified' }
Territorio class >> inferior [
    ^ self filas: 13 hasta: 24 direccionAlRival: -1

]

{ #category : 'as yet unclassified' }
Territorio class >> superior [
    ^ self filas: 1 hasta: 12 direccionAlRival: 1

]

{ #category : 'initialization' }
Territorio >> filaFinal [
    ^ filaFinal

]

{ #category : 'initialization' }
Territorio >> filaInicial [
    ^ filaInicial

]

{ #category : 'initialization' }
Territorio >> incluye: unaCoordenada [
    ^ unaCoordenada fila between: filaInicial and: filaFinal
]

{ #category : 'initialization' }
Territorio >> origenDe: unaNave [
    ^ direccionAlRival < 0
        ifTrue: [ unaNave posiciones detectMin: [ :c | c fila ] ]
        ifFalse: [ unaNave posiciones detectMax: [ :c | c fila ] ]
]

{ #category : 'initialization' }
Territorio >> setDesde: desde hasta: hasta direccion: unaDireccion [
    filaInicial := desde.
    filaFinal := hasta.
    direccionAlRival := unaDireccion

]
