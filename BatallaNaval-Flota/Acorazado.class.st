"
Representa un barco de tipo acorazado dentro de la flota y tiene un tamaño de 4 casilleros
"
Class {
	#name : 'Acorazado',
	#superclass : 'Nave',
	#category : 'BatallaNaval-Flota',
	#package : 'BatallaNaval-Flota'
}

{ #category : 'initialization' }
Acorazado >> initialize [
    super initialize.
    arma := CanionTurbo new

]

{ #category : 'accessing' }
Acorazado >> tamano [ ^ 4 
]

{ #category : 'accessing' }
Acorazado >> turnosDeRecarga [
	^5
]
