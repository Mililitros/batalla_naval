"
Tests de las islas de 3 a 4 casillas.
"
Class {
	#name : 'TableroIslasTest',
	#superclass : 'TestCase',
	#category : 'BatallaNaval-Tests',
	#package : 'BatallaNaval-Tests'
}

{ #category : 'tests' }
TableroIslasTest >> testLasIslasQuedanDentroDelTerritorioPedido [
	| tablero |
	tablero := Tablero estandar.
	tablero generarIslas: 2 en: Territorio inferior azar: Random new.
	self assert: (tablero cantidadDeIslasEn: Territorio inferior) equals: 2.
	self assert: (tablero cantidadDeIslasEn: Territorio superior) equals: 0
]

{ #category : 'tests' }
TableroIslasTest >> testLasIslasTienenTresOCuatroCasillasConectadas [
	1 to: 50 do: [ :semilla |
		| tablero tamanos |
		tablero := Tablero estandar.
		tablero generarIslas: 3 en: Territorio superior azar: (Random seed: semilla).
		tamanos := tablero tamanosDeIslasEn: Territorio superior.
		self assert: tamanos size equals: 3.
		self assert: (tamanos allSatisfy: [ :cadaTamano | cadaTamano between: 3 and: 4 ]) ]
]

{ #category : 'tests' }
TableroIslasTest >> testUnaPartidaNuevaTieneDosOTresIslasGrandesPorTerritorio [
	| partida |
	partida := Partida contraLaIA: 'Test' azar: Random new.
	{ Territorio superior. Territorio inferior } do: [ :cadaTerritorio |
		| tamanos |
		tamanos := partida tablero tamanosDeIslasEn: cadaTerritorio.
		self assert: (tamanos size between: 2 and: 3).
		self assert: (tamanos allSatisfy: [ :cadaTamano | cadaTamano between: 3 and: 4 ]) ]
]
