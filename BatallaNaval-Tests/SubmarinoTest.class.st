Class {
	#name : 'SubmarinoTest',
	#superclass : 'TestCase',
	#instVars : [
		'tablero',
		'submarino'
	],
	#category : 'BatallaNaval-Tests',
	#package : 'BatallaNaval-Tests'
}

{ #category : 'running' }
SubmarinoTest >> setUp [
    super setUp.
    tablero := Tablero estandar.
    submarino := Submarino new.
    tablero
        ubicarNave: submarino
        desde: (Coordenada fila: 20 columna: 6)
        orientacion: #vertical
        en: Territorio inferior

]

{ #category : 'tests' }
SubmarinoTest >> testAlDispararSaleAFlotePorCincoTurnos [
    submarino
        atacar: #()
        desde: (Territorio inferior origenDe: submarino)
        contra: tablero rival: Territorio superior.
    self deny: submarino estaSumergido.
    self deny: submarino puedeAtacar.
    4 timesRepeat: [ submarino avanzarRecarga ].
    self deny: submarino estaSumergido.
    submarino avanzarRecarga.
    self assert: submarino estaSumergido.
    self assert: submarino puedeAtacar

]

{ #category : 'tests' }
SubmarinoTest >> testSumergidoNoRecibeDanio [
    | resultado |
    resultado := (tablero casillaEn: (Coordenada fila: 20 columna: 6)) recibirDisparo.
    self deny: resultado esImpacto.
    self assert: submarino cantidadDeImpactos equals: 0


]
