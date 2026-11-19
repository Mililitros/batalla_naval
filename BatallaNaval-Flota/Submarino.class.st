"
Representa un barco sumergible dentro de la flota y tiene un tamaño de 3 casilleros, también gestiona su estado de inmersión
"
Class {
	#name : 'Submarino',
	#superclass : 'Nave',
	#category : 'BatallaNaval-Flota',
	#package : 'BatallaNaval-Flota'
}

{ #category : 'testing' }
Submarino >> estaSumergido [
	^recargaRestante = 0
]

{ #category : 'impacts' }
Submarino >> puedeSerImpactada [ 
	^self estaSumergido not
]

{ #category : 'accessing' }
Submarino >> tamano [ ^ 3
]
