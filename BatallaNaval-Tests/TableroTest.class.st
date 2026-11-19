Class {
	#name : 'TableroTest',
	#superclass : 'TestCase',
	#instVars : [
		'tablero',
		'crucero'
	],
	#category : 'BatallaNaval-Tests',
	#package : 'BatallaNaval-Tests'
}

{ #category : 'running' }
TableroTest >> setUp [
    super setUp.
    tablero := Tablero estandar.
    crucero := Crucero new

]

{ #category : 'tests' }
TableroTest >> testCasillaEnDevuelveLaCasillaDeEsaCoordenada [
    | coordenada |
    coordenada := Coordenada fila: 4 columna: 7.
    self assert: (tablero casillaEn: coordenada) coordenada equals: coordenada
]

{ #category : 'tests' }
TableroTest >> testCasillaEnFueraDelTableroFalla [
    self
        should: [ tablero casillaEn: (Coordenada fila: 13 columna: 1) ]
        raise: CoordenadaFueraDelTablero
]

{ #category : 'tests' }
TableroTest >> testCoordenadaValidaSoloDentroDelTablero [
    self assert: (tablero coordenadaValida: (Coordenada fila: 1 columna: 1)).
    self assert: (tablero coordenadaValida: (Coordenada fila: 12 columna: 12)).
    self deny: (tablero coordenadaValida: (Coordenada fila: 0 columna: 5)).
    self deny: (tablero coordenadaValida: (Coordenada fila: 13 columna: 5)).
    self deny: (tablero coordenadaValida: (Coordenada fila: 5 columna: 13))

]

{ #category : 'tests' }
TableroTest >> testNoSePuedeUbicarUnaNaveQueSeSaleDelTablero [
    self
        should: [ tablero ubicarNave: crucero desde: (Coordenada fila: 3 columna: 11) orientacion: #horizontal ]
        raise: UbicacionInvalida.
    self deny: (tablero casillaEn: (Coordenada fila: 3 columna: 11)) estaOcupada
]

{ #category : 'tests' }
TableroTest >> testNoSePuedenSuperponerNaves [
    tablero ubicarNave: crucero desde: (Coordenada fila: 3 columna: 3) orientacion: #horizontal.
    self
        should: [ tablero ubicarNave: Destructor new desde: (Coordenada fila: 2 columna: 4) orientacion: #vertical ]
        raise: UbicacionInvalida.
    self deny: (tablero casillaEn: (Coordenada fila: 2 columna: 4)) estaOcupada
]

{ #category : 'tests' }
TableroTest >> testOrientacionInvalida [
    self
        should: [ tablero ubicarNave: crucero desde: (Coordenada fila: 3 columna: 3) orientacion: #diagonal ]
        raise: UbicacionInvalida
]

{ #category : 'tests' }
TableroTest >> testUbicarNaveHorizontal [
    tablero ubicarNave: crucero desde: (Coordenada fila: 3 columna: 3) orientacion: #horizontal.
    self assert: (tablero casillaEn: (Coordenada fila: 3 columna: 3)) nave equals: crucero.
    self assert: (tablero casillaEn: (Coordenada fila: 3 columna: 5)) nave equals: crucero.
    self deny: (tablero casillaEn: (Coordenada fila: 3 columna: 6)) estaOcupada

]

{ #category : 'tests' }
TableroTest >> testUbicarNaveVertical [
    tablero ubicarNave: crucero desde: (Coordenada fila: 3 columna: 3) orientacion: #vertical.
    self assert: (tablero casillaEn: (Coordenada fila: 5 columna: 3)) nave equals: crucero.
    self deny: (tablero casillaEn: (Coordenada fila: 3 columna: 4)) estaOcupada

]

{ #category : 'tests' }
TableroTest >> testUnTableroEstandarTiene144Casillas [
    self assert: tablero cantidadDeCasillas equals: 144

]
