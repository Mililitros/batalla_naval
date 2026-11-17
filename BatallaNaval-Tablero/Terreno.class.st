"
Representa el tipo de superficie abstracta que puede tener una casilla del tablero 
"
Class {
	#name : 'Terreno',
	#superclass : 'Object',
	#category : 'BatallaNaval-Tablero',
	#package : 'BatallaNaval-Tablero'
}

{ #category : 'events' }
Terreno >> alUbicarNave: unaNave en: unaCasilla [
    ^ self subclassResponsibility
]

{ #category : 'tests' }
Terreno >> esCampoMinado [
    ^ false

]
