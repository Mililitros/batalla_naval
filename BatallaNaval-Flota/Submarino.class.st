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
Submarino >> estaInalcanzableDesde: unOrigen contra: unTablero rival: unTerritorio [
    ^ (super estaInalcanzableDesde: unOrigen contra: unTablero rival: unTerritorio)
        or: [ self hayIslaDescubiertaEnLaColumnaDe: unOrigen en: unTablero rival: unTerritorio ]
]

{ #category : 'testing' }
Submarino >> estaSumergido [
	^recargaRestante = 0
]

{ #category : 'testing' }
Submarino >> hayIslaDescubiertaEnLaColumnaDe: unOrigen en: unTablero rival: unTerritorio [
    ^ (unTerritorio filaInicial to: unTerritorio filaFinal) anySatisfy: [ :fila |
        | casilla |
        casilla := unTablero casillaEn: (Coordenada fila: fila columna: unOrigen columna).
        casilla terreno esIsla and: [ casilla estaRevelada ] ]
]

{ #category : 'initialization' }
Submarino >> initialize [
    super initialize.
    arma := Torpedo new

]

{ #category : 'impacts' }
Submarino >> puedeSerImpactada [ 
	^self estaSumergido not
]

{ #category : 'accessing' }
Submarino >> tamano [ ^ 3
]

{ #category : 'accessing' }
Submarino >> turnosDeRecarga [
    ^7

]
