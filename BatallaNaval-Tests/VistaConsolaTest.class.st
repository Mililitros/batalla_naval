Class {
	#name : 'VistaConsolaTest',
	#superclass : 'TestCase',
	#instVars : [
		'salida',
		'vista'
	],
	#category : 'BatallaNaval-Tests',
	#package : 'BatallaNaval-Tests'
}

{ #category : 'running' }
VistaConsolaTest >> setUp [

	super setUp.
	salida := WriteStream on: String new.
	vista := VistaConsola salida: salida
]

{ #category : 'tests' }
VistaConsolaTest >> testMostrarErrorAntepoleLaPalabraError [

	vista mostrarError: 'algo falló'.
	self assert: (self textoMostrado includesSubstring: 'Error: algo falló')
]

{ #category : 'tests' }
VistaConsolaTest >> testMostrarGanadorNombraAlGanadorOAvisaElEmpate [

	vista mostrarGanador: (Jugador nombre: 'Ana' territorio: Territorio inferior).
	self assert: (self textoMostrado includesSubstring: 'Ganador: Ana').
	vista mostrarGanador: nil.
	self assert: (self textoMostrado includesSubstring: 'empate')
]

{ #category : 'tests' }
VistaConsolaTest >> testMostrarNavesNumeraYDescribeCadaNave [

	vista mostrarNaves: Flota estandar naves.
	self assert: (self textoMostrado includesSubstring: '1) Portaaviones (tamaño 5)').
	self assert: (self textoMostrado includesSubstring: 'lista para atacar')
]

{ #category : 'tests' }
VistaConsolaTest >> testMostrarResultadosDescribeCadaTipoDeResultado [

	vista mostrarResultados: {
		ResultadoAgua new.
		(ResultadoImpacto coordenada: (Coordenada fila: 5 columna: 3)).
		(ResultadoHundido coordenada: (Coordenada fila: 5 columna: 4)).
		ResultadoBloqueado new }.
	self assert: (self textoMostrado includesSubstring: 'Agua').
	self assert: (self textoMostrado includesSubstring: 'Impacto en C5').
	self assert: (self textoMostrado includesSubstring: 'Hundido! en D5').
	self assert: (self textoMostrado includesSubstring: 'isla')
]

{ #category : 'tests' }
VistaConsolaTest >> testMostrarTableroDibujaUnaLineaPorFilaMasElEncabezado [

	vista mostrarTablero: Tablero estandar vistaCompleta.
	self assert: self textoMostrado lines size equals: 25
]

{ #category : 'tests' }
VistaConsolaTest >> testMostrarTableroIncluyeElEncabezadoConLasLetrasDeLasColumnas [

	vista mostrarTablero: Tablero estandar vistaCompleta.
	self assert: (self textoMostrado includesSubstring: 'A B C D E F G H I J K L')
]

{ #category : 'tests' }
VistaConsolaTest >> testMostrarTableroTraduceCadaSimboloAUnCaracter [

	vista mostrarTablero: { { #libre. #agua. #nave. #impacto. #hundida. #isla. #oculta } }.
	self assert: (self textoMostrado includesSubstring: '. ~ N X # I ?')
]

{ #category : 'tests' }
VistaConsolaTest >> testMostrarUltimoAtaqueNombraAlJugadorLaNaveYLosObjetivos [

	| jugador ataque |
	jugador := Jugador nombre: 'Ana' territorio: Territorio inferior.
	ataque := { jugador. Destructor new. { Coordenada fila: 5 columna: 3 }. { ResultadoAgua new } }.
	vista mostrarUltimoAtaque: ataque.
	self assert: (self textoMostrado includesSubstring: 'Ana').
	self assert: (self textoMostrado includesSubstring: 'Destructor').
	self assert: (self textoMostrado includesSubstring: 'C5')
]

{ #category : 'tests' }
VistaConsolaTest >> testMostrarUltimoAtaqueSinAtaqueAvisaQueNoHubo [

	vista mostrarUltimoAtaque: nil.
	self assert: (self textoMostrado includesSubstring: 'No hubo ataque')
]

{ #category : 'tests' }
VistaConsolaTest >> testOpcionDesdeTextoAceptaSoloNumerosDelRango [

	self assert: (vista opcionDesdeTexto: ' 2 ' entre: 1 y: 3) equals: 2.
	self should: [ vista opcionDesdeTexto: '4' entre: 1 y: 3 ] raise: EntradaInvalida.
	self should: [ vista opcionDesdeTexto: 'a' entre: 1 y: 3 ] raise: EntradaInvalida
]

{ #category : 'tests' }
VistaConsolaTest >> testOrientacionDesdeTextoAceptaHYVSinImportarMayusculas [

	self assert: (vista orientacionDesdeTexto: 'h') equals: #horizontal.
	self assert: (vista orientacionDesdeTexto: ' V ') equals: #vertical
]

{ #category : 'tests' }
VistaConsolaTest >> testOrientacionDesdeTextoRechazaCualquierOtraCosa [

	self should: [ vista orientacionDesdeTexto: 'x' ] raise: EntradaInvalida.
	self should: [ vista orientacionDesdeTexto: '' ] raise: EntradaInvalida
]

{ #category : 'as yet unclassified' }
VistaConsolaTest >> textoMostrado [

	^ salida contents
]
