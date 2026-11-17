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
    explotada := true.
    unaCasilla recibirDisparo
]

{ #category : 'tests' }
CampoMinado >> esCampoMinado [
    ^ true

]

{ #category : 'tests' }
CampoMinado >> explotada [
    ^ explotada
]

{ #category : 'initialization' }
CampoMinado >> initialize [
    super initialize.
    explotada := false
]
