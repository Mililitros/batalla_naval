"
Vista de consola del juego. Muestra tableros, naves, resultados y errores en el Transcript, y le pide al usuario coordenadas, orientaciones y opciones de menú. No conoce las reglas del juego: solo presenta los datos que le entrega ControladorConsola.
"
Class {
	#name : 'VistaConsola',
	#superclass : 'Object',
	#instVars : [
		'salida'
	],
	#category : 'BatallaNaval-Interfaz',
	#package : 'BatallaNaval-Interfaz'
}

{ #category : 'as yet unclassified' }
VistaConsola class >> salida: unStream [

	^ self new setSalida: unStream
]

{ #category : 'private' }
VistaConsola >> caracterPara: unSimbolo [

	^ self referencias at: unSimbolo ifAbsent: [ '?' ]
]

{ #category : 'private' }
VistaConsola >> descripcionDe: unaNave [

	^ unaNave class name asString, ' (tamaño ', unaNave tamano printString, ')',
		' - objetivos: ', unaNave arma cantidadDeObjetivos printString,
		', alcance: ', unaNave arma alcance printString,
		' - ', (self estadoDe: unaNave)
]

{ #category : 'private' }
VistaConsola >> descripcionDeResultado: unResultado [

	unResultado esHundido ifTrue: [ ^ '¡Hundido! en ', unResultado coordenada comoTexto ].
	unResultado esImpacto ifTrue: [ ^ 'Impacto en ', unResultado coordenada comoTexto ].
	unResultado esBloqueado ifTrue: [ ^ 'El disparo chocó con una isla' ].
	^ 'Agua'
]

{ #category : 'private' }
VistaConsola >> encabezadoPara: cantidadDeColumnas [

	^ '   ', (' ' join: ((1 to: cantidadDeColumnas) collect: [ :columna |
		(Character value: 64 + columna) asString ]))
]

{ #category : 'private' }
VistaConsola >> escribir: unTexto [

	salida nextPutAll: unTexto; cr.
	salida flush
]

{ #category : 'private' }
VistaConsola >> estadoDe: unaNave [

	unaNave estaHundida ifTrue: [ ^ 'hundida' ].
	unaNave puedeAtacar ifTrue: [ ^ 'lista para atacar' ].
	^ 'recargando (', unaNave recargaRestante printString, ' turnos)'
]

{ #category : 'initialization' }
VistaConsola >> initialize [

	super initialize.
	salida := Transcript
]

{ #category : 'private' }
VistaConsola >> lineaDeFila: unaFila numero: unNumero [

	^ (unNumero printPaddedWith: Character space to: 2), ' ',
		(' ' join: (unaFila collect: [ :simbolo | self caracterPara: simbolo ]))
]

{ #category : 'mostrar' }
VistaConsola >> mostrarError: unTexto [

	self escribir: 'Error: ', unTexto
]

{ #category : 'mostrar' }
VistaConsola >> mostrarGanador: unJugador [

	unJugador isNil ifTrue: [
		^ self escribir: 'La partida terminó en empate.' ].
	self escribir: 'La partida terminó. Ganador: ', unJugador nombre
]

{ #category : 'mostrar' }
VistaConsola >> mostrarLeyenda [

	self escribir: 'Referencias: . libre   ~ agua   N nave   X impacto   # hundida   I isla   ? sin descubrir'
]

{ #category : 'mostrar' }
VistaConsola >> mostrarMensaje: unTexto [

	self escribir: unTexto
]

{ #category : 'mostrar' }
VistaConsola >> mostrarNaves: unasNaves [

	unasNaves withIndexDo: [ :nave :indice |
		self escribir: indice printString, ') ', (self descripcionDe: nave) ]
]

{ #category : 'mostrar' }
VistaConsola >> mostrarResultados: unosResultados [

	unosResultados do: [ :resultado |
		self escribir: (self descripcionDeResultado: resultado) ]
]

{ #category : 'mostrar' }
VistaConsola >> mostrarTablero: unaMatriz [

	self escribir: (self encabezadoPara: unaMatriz first size).
	unaMatriz withIndexDo: [ :fila :numero |
		self escribir: (self lineaDeFila: fila numero: numero) ]
]

{ #category : 'mostrar' }
VistaConsola >> mostrarTurnoDe: unJugador [

	self escribir: ''.
	self escribir: '=== Turno de ', unJugador nombre, ' ==='
]

{ #category : 'mostrar' }
VistaConsola >> mostrarUltimoAtaque: unAtaque [

	| jugador nave objetivos resultados |
	unAtaque isNil ifTrue: [
		^ self escribir: 'No hubo ataque (se reubicó una nave o se pasó el turno).' ].
	jugador := unAtaque first.
	nave := unAtaque second.
	objetivos := unAtaque third.
	resultados := unAtaque fourth.
	self escribir: jugador nombre, ' atacó con un ', nave class name asString, (self textoDeObjetivos: objetivos), '.'.
	self mostrarResultados: resultados
]

{ #category : 'pedir datos' }
VistaConsola >> opcionDesdeTexto: unTexto entre: unMinimo y: unMaximo [

	| texto numero |
	texto := unTexto trimBoth.
	(texto notEmpty and: [ texto allSatisfy: [ :cadaCaracter | cadaCaracter isDigit ] ])
		ifTrue: [
			numero := texto asInteger.
			(numero between: unMinimo and: unMaximo) ifTrue: [ ^ numero ] ].
	^ EntradaInvalida new signal: 'Elegí un número entre ', unMinimo printString, ' y ', unMaximo printString
]

{ #category : 'pedir datos' }
VistaConsola >> orientacionDesdeTexto: unTexto [

	| letra |
	letra := unTexto trimBoth asUppercase.
	letra = 'H' ifTrue: [ ^ #horizontal ].
	letra = 'V' ifTrue: [ ^ #vertical ].
	^ EntradaInvalida new signal: 'Escribí H (horizontal) o V (vertical)'
]

{ #category : 'pedir datos' }
VistaConsola >> pedirCoordenada: unaPregunta [

	[ | texto |
	texto := self pedirTexto: unaPregunta.
	texto isNil ifTrue: [ ^ nil ].
	^ Coordenada desdeTexto: texto ]
		on: EntradaInvalida
		do: [ :error |
			self mostrarError: error messageText.
			error retry ]
]

{ #category : 'pedir datos' }
VistaConsola >> pedirOpcion: unaPregunta entre: unMinimo y: unMaximo [

	[ | texto |
	texto := self pedirTexto: unaPregunta, ' [', unMinimo printString, '-', unMaximo printString, ']'.
	texto isNil ifTrue: [ ^ nil ].
	^ self opcionDesdeTexto: texto entre: unMinimo y: unMaximo ]
		on: EntradaInvalida
		do: [ :error |
			self mostrarError: error messageText.
			error retry ]
]

{ #category : 'pedir datos' }
VistaConsola >> pedirOrientacion [

	[ | texto |
	texto := self pedirTexto: 'Orientación (H = horizontal, V = vertical)'.
	texto isNil ifTrue: [ ^ nil ].
	^ self orientacionDesdeTexto: texto ]
		on: EntradaInvalida
		do: [ :error |
			self mostrarError: error messageText.
			error retry ]
]

{ #category : 'pedir datos' }
VistaConsola >> pedirTexto: unaPregunta [

	^ UIManager default request: unaPregunta initialAnswer: ''
]

{ #category : 'private' }
VistaConsola >> referencias [

	^ { #libre -> '.'. #agua -> '~'. #nave -> 'N'. #impacto -> 'X'.
		#hundida -> '#'. #isla -> 'I'. #oculta -> '?' } asDictionary
]

{ #category : 'initialization' }
VistaConsola >> setSalida: unStream [

	salida := unStream
]

{ #category : 'private' }
VistaConsola >> textoDeObjetivos: unasCoordenadas [

	unasCoordenadas isEmpty ifTrue: [ ^ ' (sin objetivos elegidos)' ].
	^ ' a ', (', ' join: (unasCoordenadas collect: [ :cadaCoordenada | cadaCoordenada comoTexto ]))
]
