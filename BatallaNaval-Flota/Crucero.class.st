"
Representa un barco de tipo crucero dentro de la flota y tiene un tamaño de 3 casilleros
"
Class {
	#name : 'Crucero',
	#superclass : 'Nave',
	#category : 'BatallaNaval-Flota',
	#package : 'BatallaNaval-Flota'
}

{ #category : 'initialization' }
Crucero >> initialize [
    super initialize.
    arma := TorpedoHorizontal new

]

{ #category : 'accessing' }
Crucero >> tamano [ ^ 3 
]

{ #category : 'accessing' }
Crucero >> turnosDeRecarga [ 
	^4
]
