"
Representa una casilla especial con minas que si los barcos se ubican sobre ella revela una casilla de donde está el barco 
"
Class {
	#name : 'CampoMinado',
	#superclass : 'Terreno',
	#instVars : [
		'explotada'
	],
	#category : 'BatallaNaval-Tablero',
	#package : 'BatallaNaval-Tablero'
}

{ #category : 'events' }
CampoMinado >> alUbicarNave: unaNave en: unaCasilla [
    explotada ifTrue: [ ^ self ].
    explotada := true.
    unaCasilla recibirDisparo
]

{ #category : 'events' }
CampoMinado >> esCampoMinado [
	^true 
]

{ #category : 'events' }
CampoMinado >> explotada [
	^explotada
]

{ #category : 'initialization' }
CampoMinado >> initialize [
    super initialize.
    explotada := false
]
