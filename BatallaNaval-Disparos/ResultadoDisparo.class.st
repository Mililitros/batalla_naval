"
Representa el resultado abstracto de efectuar un disparo sobre una casilla del tablero
"
Class {
	#name : 'ResultadoDisparo',
	#superclass : 'Object',
	#category : 'BatallaNaval-Disparos',
	#package : 'BatallaNaval-Disparos'
}

{ #category : 'testing' }
ResultadoDisparo >> esBloqueado [
    ^ false

]

{ #category : 'testing' }
ResultadoDisparo >> esHundido [
	^ false



]

{ #category : 'testing' }
ResultadoDisparo >> esImpacto [
	^ false


]
