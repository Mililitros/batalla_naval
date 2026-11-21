"
Controlador de la versión por consola: coordina la Partida con la VistaConsola. Prepara la partida, alterna los turnos del humano y de la IA y muestra el resultado. No imprime ni implementa reglas del juego.
"
Class {
	#name : 'ControladorConsola',
	#superclass : 'Object',
	#instVars : [
		'partida',
		'vista',
		'azar'
	],
	#category : 'BatallaNaval-Interfaz',
	#package : 'BatallaNaval-Interfaz'
}

{ #category : 'turno del humano' }
ControladorConsola >> atacarComoHumano [

	| nave objetivos |
	nave := self elegirNaveParaAtacar.
	nave isNil ifTrue: [ ^ self ].
	objetivos := self pedirObjetivosPara: nave.
	objetivos isNil ifTrue: [ ^ self ].
	[ partida atacarCon: nave objetivos: objetivos.
	vista mostrarUltimoAtaque: partida ultimoAtaque ]
		on: ErrorDeBatallaNaval
		do: [ :error | vista mostrarError: error messageText ]
]

{ #category : 'accessing' }
ControladorConsola >> azar: unRandom [

	azar := unRandom
]

{ #category : 'jugando' }
ControladorConsola >> crearPartidaContraLaIA [

	| nombre |
	nombre := vista pedirTexto: 'Tu nombre'.
	(nombre isNil or: [ nombre trimBoth isEmpty ]) ifTrue: [ nombre := 'Jugador' ].
	partida := Partida contraLaIA: nombre trimBoth azar: azar
]

{ #category : 'jugando' }
ControladorConsola >> demoAutomatica [

	partida := Partida entreIAs: azar.
	vista mostrarMensaje: 'DEMO: ', partida jugadores first nombre, ' contra ', partida jugadores last nombre.
	vista mostrarTablero: partida tablero vistaCompleta.
	[ partida estaFinalizada ] whileFalse: [
		self turnoAutomatico.
		vista mostrarTablero: partida tablero vistaCompleta ].
	self mostrarFinDeLaPartida
]

{ #category : 'turno del humano' }
ControladorConsola >> elegirNaveParaAtacar [

	| candidatas indice |
	candidatas := partida jugadorActual flota navesQuePuedenAtacar.
	candidatas isEmpty ifTrue: [
		vista mostrarError: 'Ninguna de tus naves puede atacar ahora.'.
		^ nil ].
	vista mostrarNaves: candidatas.
	indice := vista pedirOpcion: 'Elegí la nave con la que atacar' entre: 1 y: candidatas size.
	^ indice isNil ifTrue: [ nil ] ifFalse: [ candidatas at: indice ]
]

{ #category : 'initialization' }
ControladorConsola >> initialize [

	super initialize.
	vista := VistaConsola new.
	azar := Random new
]

{ #category : 'jugando' }
ControladorConsola >> jugarPartida [

	self crearPartidaContraLaIA.
	self prepararMinas.
	self prepararNaves.
	[ partida estaFinalizada ] whileFalse: [
		partida jugadorActual esAutomatico
			ifTrue: [ self turnoAutomatico ]
			ifFalse: [ self turnoDelHumano ] ].
	self mostrarFinDeLaPartida
]

{ #category : 'jugando' }
ControladorConsola >> mostrarFinDeLaPartida [

	vista mostrarTablero: partida tablero vistaCompleta.
	vista mostrarLeyenda.
	vista mostrarGanador: partida ganador
]

{ #category : 'accessing' }
ControladorConsola >> partida [

	^ partida
]

{ #category : 'turno del humano' }
ControladorConsola >> pedirObjetivosPara: unaNave [

	| cantidad objetivos coordenada |
	cantidad := unaNave arma cantidadDeObjetivos.
	objetivos := OrderedCollection new.
	1 to: cantidad do: [ :numero |
		coordenada := vista pedirCoordenada: 'Objetivo ', numero printString, ' de ',
			cantidad printString, ' (ej: C5)'.
		coordenada isNil ifTrue: [ ^ nil ].
		objetivos add: coordenada ].
	^ objetivos asArray
]

{ #category : 'preparacion' }
ControladorConsola >> prepararMinas [

	| rival opcion |
	rival := (partida rivalDe: partida jugadorHumano) territorio.
	vista mostrarMensaje: 'FASE 1: ubicá tus ', partida jugadorHumano minasRestantes printString,
		' minas en el campo rival (filas ', rival filaInicial printString, ' a ', rival filaFinal printString, ').'.
	opcion := vista pedirOpcion: '1 = ubicarlas yo, 2 = ubicarlas al azar' entre: 1 y: 2.
	(opcion isNil or: [ opcion = 2 ]) ifTrue: [ ^ partida ubicarMinasAlAzar ].
	[ partida estado = #colocandoMinas ] whileTrue: [ self ubicarUnaMina ]
]

{ #category : 'preparacion' }
ControladorConsola >> prepararNaves [

	| opcion |
	vista mostrarMensaje: 'FASE 2: ubicá tus naves en tu campo.'.
	opcion := vista pedirOpcion: '1 = ubicarlas yo, 2 = ubicarlas al azar' entre: 1 y: 2.
	(opcion isNil or: [ opcion = 2 ]) ifTrue: [ ^ partida ubicarNavesAlAzar ].
	[ partida estado = #colocandoNaves ] whileTrue: [ self ubicarSiguienteNave ]
]

{ #category : 'turno del humano' }
ControladorConsola >> reubicarComoHumano [

	| humano candidatas indice nave coordenada orientacion |
	humano := partida jugadorActual.
	candidatas := humano navesOperativas select: [ :cadaNave |
		cadaNave
			puedeReubicarseDesde: (humano territorio origenDe: cadaNave)
			contra: partida tablero
			rival: partida jugadorRival territorio ].
	candidatas isEmpty ifTrue: [
		^ vista mostrarError: 'Ninguna nave puede reubicarse (deben estar intactas y fuera del alcance rival).' ].
	vista mostrarNaves: candidatas.
	indice := vista pedirOpcion: 'Elegí la nave a reubicar' entre: 1 y: candidatas size.
	indice isNil ifTrue: [ ^ self ].
	nave := candidatas at: indice.
	coordenada := vista pedirCoordenada: 'Nueva coordenada inicial (ej: M15)'.
	coordenada isNil ifTrue: [ ^ self ].
	orientacion := vista pedirOrientacion.
	orientacion isNil ifTrue: [ ^ self ].
	[ partida reubicar: nave desde: coordenada orientacion: orientacion.
	vista mostrarMensaje: 'Nave reubicada.' ]
		on: ErrorDeBatallaNaval
		do: [ :error | vista mostrarError: error messageText ]
]

{ #category : 'jugando' }
ControladorConsola >> turnoAutomatico [

	| jugador |
	jugador := partida jugadorActual.
	jugador jugarTurno: partida.
	vista mostrarMensaje: jugador nombre, ' jugó su turno.'.
	vista mostrarUltimoAtaque: partida ultimoAtaque
]

{ #category : 'turno del humano' }
ControladorConsola >> turnoDelHumano [

	| humano opcion |
	humano := partida jugadorActual.
	vista mostrarTurnoDe: humano.
	vista mostrarTablero: (partida tablero vistaPara: humano territorio).
	vista mostrarLeyenda.
	opcion := vista
		pedirOpcion: '1 = Atacar, 2 = Reubicar una nave, 3 = Pasar el turno, 4 = Terminar la partida'
		entre: 1 y: 4.
	opcion isNil ifTrue: [ opcion := 4 ].
	opcion = 1 ifTrue: [ ^ self atacarComoHumano ].
	opcion = 2 ifTrue: [ ^ self reubicarComoHumano ].
	opcion = 3 ifTrue: [
		partida pasarTurno.
		^ vista mostrarMensaje: 'Pasaste el turno.' ].
	partida terminarPorTiempo
]

{ #category : 'preparacion' }
ControladorConsola >> ubicarSiguienteNave [

	| humano nave coordenada orientacion |
	humano := partida jugadorHumano.
	nave := humano navesSinUbicar first.
	vista mostrarTablero: (partida tablero vistaPara: humano territorio).
	vista mostrarLeyenda.
	vista mostrarMensaje: 'Ubicá: ', nave class name asString, ' (tamaño ', nave tamano printString, ')'.
	coordenada := vista pedirCoordenada: 'Coordenada inicial (ej: M15)'.
	coordenada isNil ifTrue: [ ^ partida ubicarNavesAlAzar ].
	orientacion := vista pedirOrientacion.
	orientacion isNil ifTrue: [ ^ partida ubicarNavesAlAzar ].
	[ partida ubicarNave: nave desde: coordenada orientacion: orientacion ]
		on: ErrorDeBatallaNaval
		do: [ :error | vista mostrarError: error messageText ]
]

{ #category : 'preparacion' }
ControladorConsola >> ubicarUnaMina [

	| coordenada |
	coordenada := vista pedirCoordenada: 'Mina (te quedan ',
		partida jugadorHumano minasRestantes printString, '). Coordenada en el campo rival (ej: C5)'.
	coordenada isNil ifTrue: [ ^ partida ubicarMinasAlAzar ].
	[ partida ubicarMinaEn: coordenada.
	vista mostrarMensaje: 'Mina ubicada en ', coordenada comoTexto ]
		on: ErrorDeBatallaNaval
		do: [ :error | vista mostrarError: error messageText ]
]

{ #category : 'accessing' }
ControladorConsola >> vista: unaVista [

	vista := unaVista
]
