Class {
	#name : 'Isla',
	#superclass : 'Terreno',
	#category : 'BatallaNaval-Tablero',
	#package : 'BatallaNaval-Tablero'
}

{ #category : 'as yet unclassified' }
Isla >> alUbicarNave: unaNave en: unaCasilla [
    ^ self
]

{ #category : 'as yet unclassified' }
Isla >> esIsla [
    ^ true
]

{ #category : 'as yet unclassified' }
Isla >> permiteColocacion [
    ^ false
]
