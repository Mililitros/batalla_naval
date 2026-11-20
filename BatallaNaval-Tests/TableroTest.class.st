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
        should: [ tablero casillaEn: (Coordenada fila: 25 columna: 1) ]
        raise: CoordenadaFueraDelTablero
]

{ #category : 'tests' }
TableroTest >> testCoordenadaValidaSoloDentroDelTablero [
    self assert: (tablero coordenadaValida: (Coordenada fila: 1 columna: 1)).
    self assert: (tablero coordenadaValida: (Coordenada fila: 24 columna: 12)).
    self deny: (tablero coordenadaValida: (Coordenada fila: 0 columna: 5)).
    self deny: (tablero coordenadaValida: (Coordenada fila: 25 columna: 1)).
    self deny: (tablero coordenadaValida: (Coordenada fila: 1 columna: 13))

]

{ #category : 'tests' }
TableroTest >> testNoSePuedeUbicarUnaNaveQueSeSaleDelTablero [
    self
        should: [ tablero ubicarNave: crucero desde: (Coordenada fila: 15 columna: 11) orientacion: #horizontal en: Territorio inferior ]
        raise: UbicacionInvalida.
    self deny: (tablero casillaEn: (Coordenada fila: 15 columna: 11)) estaOcupada

]

{ #category : 'tests' }
TableroTest >> testNoSePuedenSuperponerNaves [
    tablero ubicarNave: crucero desde: (Coordenada fila: 15 columna: 3) orientacion: #horizontal en: Territorio inferior.
    self
        should: [ tablero ubicarNave: Destructor new desde: (Coordenada fila: 14 columna: 4) orientacion: #vertical en: Territorio inferior ]
        raise: UbicacionInvalida.
    self deny: (tablero casillaEn: (Coordenada fila: 14 columna: 4)) estaOcupada

]

{ #category : 'tests' }
TableroTest >> testOrientacionInvalida [
    self
        should: [ tablero ubicarNave: crucero desde: (Coordenada fila: 15 columna: 3) orientacion: #diagonal en: Territorio inferior ]
        raise: UbicacionInvalida

]

{ #category : 'tests' }
TableroTest >> testReubicarMueveLaNave [
    tablero ubicarNave: crucero desde: (Coordenada fila: 15 columna: 3) orientacion: #horizontal en: Territorio inferior.
    tablero reubicarNave: crucero desde: (Coordenada fila: 20 columna: 3) orientacion: #horizontal en: Territorio inferior.
    self deny: (tablero casillaEn: (Coordenada fila: 15 columna: 3)) estaOcupada.
    self assert: (tablero casillaEn: (Coordenada fila: 20 columna: 3)) nave equals: crucero
]

{ #category : 'tests' }
TableroTest >> testUbicarNaveHorizontal [
    tablero ubicarNave: crucero desde: (Coordenada fila: 15 columna: 3) orientacion: #horizontal en: Territorio inferior.
    self assert: (tablero casillaEn: (Coordenada fila: 15 columna: 3)) nave equals: crucero.
    self assert: (tablero casillaEn: (Coordenada fila: 15 columna: 5)) nave equals: crucero.
    self deny: (tablero casillaEn: (Coordenada fila: 15 columna: 6)) estaOcupada

]

{ #category : 'tests' }
TableroTest >> testUbicarNaveVertical [
    tablero ubicarNave: crucero desde: (Coordenada fila: 15 columna: 3) orientacion: #vertical en: Territorio inferior.
    self assert: (tablero casillaEn: (Coordenada fila: 17 columna: 3)) nave equals: crucero.
    self deny: (tablero casillaEn: (Coordenada fila: 15 columna: 4)) estaOcupada

]

{ #category : 'tests' }
TableroTest >> testUnTableroEstandarTiene288Casillas [
    self assert: tablero cantidadDeCasillas equals: 288

]

{ #category : 'tests' }
TableroTest >> testUnaMinaPersistenteExplotaAlReubicar [
    tablero ubicarMinaEn: (Coordenada fila: 20 columna: 4) en: Territorio inferior.
    tablero ubicarNave: crucero desde: (Coordenada fila: 15 columna: 3) orientacion: #horizontal en: Territorio inferior.
    self assert: crucero cantidadDeImpactos equals: 0.
    tablero reubicarNave: crucero desde: (Coordenada fila: 20 columna: 3) orientacion: #horizontal en: Territorio inferior.
    self assert: crucero cantidadDeImpactos equals: 1

]

{ #category : 'tests' }
TableroTest >> testUnaNaveDaniadaNoPuedeReubicarse [
    tablero ubicarNave: crucero desde: (Coordenada fila: 15 columna: 3) orientacion: #horizontal en: Territorio inferior.
    (tablero casillaEn: (Coordenada fila: 15 columna: 3)) recibirDisparo.
    self
        should: [ tablero reubicarNave: crucero desde: (Coordenada fila: 20 columna: 3) orientacion: #horizontal en: Territorio inferior ]
        raise: UbicacionInvalida

]
