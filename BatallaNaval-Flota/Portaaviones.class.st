"
Representa una embarcación de tipo portaaviones (sublcase de Nave) con un tamaño de 5 casilleros
"
Class {
	#name : 'Portaaviones',
	#superclass : 'Nave',
	#category : 'BatallaNaval-Flota',
	#package : 'BatallaNaval-Flota'
}

{ #category : 'initialization' }
Portaaviones >> initialize [
    super initialize.
    arma := BombardeoAereo new

]

{ #category : 'accessing' }
Portaaviones >> tamano [ ^ 5
]

{ #category : 'accessing' }
Portaaviones >> turnosDeRecarga [ 
	^4
]
