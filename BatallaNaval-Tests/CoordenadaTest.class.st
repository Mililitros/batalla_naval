Class {
	#name : 'CoordenadaTest',
	#superclass : 'TestCase',
	#category : 'BatallaNaval-Tests',
	#package : 'BatallaNaval-Tests'
}

{ #category : 'tests' }
CoordenadaTest >> testComoTexto [
	self assert: (Coordenada fila: 8 columna: 8) comoTexto equals: 'H8'.
	self assert: (Coordenada fila: 12 columna: 12) comoTexto equals: 'L12'

]

{ #category : 'tests' }
CoordenadaTest >> testCoordenadasConDistintosValoresNoSonIguales [
	self deny: (Coordenada fila: 8 columna: 8) = (Coordenada fila: 8 columna: 9)

]

{ #category : 'tests' }
CoordenadaTest >> testDesdeTexto [
    self assert: (Coordenada desdeTexto: 'H8') equals: (Coordenada fila: 8 columna: 8).
    self assert: (Coordenada desdeTexto: ' a24 ') equals: (Coordenada fila: 24 columna: 1)

]

{ #category : 'tests' }
CoordenadaTest >> testDesdeTextoInvalido [
    self should: [ Coordenada desdeTexto: '8H' ] raise: EntradaInvalida.
    self should: [ Coordenada desdeTexto: 'zz' ] raise: EntradaInvalida
]

{ #category : 'tests' }
CoordenadaTest >> testDosCoordenadasConLosMismosValoresSonIguales [
	self 
		assert: (Coordenada fila: 8 columna: 8)
		equals: (Coordenada fila: 8 columna: 8)
		
]

{ #category : 'tests' }
CoordenadaTest >> testSePuedeUsarComoClaveDeUnDiccionario [

	| casillas |
	casillas := Dictionary new.
	casillas at: (Coordenada fila: 3 columna: 5) put: #casilla.
	self
		assert: (casillas at: (Coordenada fila: 3 columna: 5))
		equals: #casilla

]
