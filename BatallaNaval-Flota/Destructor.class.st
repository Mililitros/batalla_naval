"
Representa un barco ligero de tipo destructor dentro de la flota y tiene un tamaño de 2 casilleros 
"
Class {
	#name : 'Destructor',
	#superclass : 'Nave',
	#category : 'BatallaNaval-Flota',
	#package : 'BatallaNaval-Flota'
}

{ #category : 'testing' }
Destructor >> concedeTurnoExtraTras: unosResultados [
    ^ unosResultados anySatisfy: [ :cadaResultado | cadaResultado esImpacto ]

]

{ #category : 'initialization' }
Destructor >> initialize [
    super initialize.
    arma := Canion new

]

{ #category : 'accessing' }
Destructor >> tamano [ ^ 2 
]
