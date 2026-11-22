"
Conecta la interfaz Morphic con la Partida y narra los turnos de la IA.
"
Class {
	#name : 'ControladorGrafico',
	#superclass : 'Object',
	#instVars : [
		'partida',
		'azar',
		'ventana',
		'demo',
		'seleccion',
		'modo',
		'orientacion',
		'objetivos',
		'bloqueado',
		'aviso',
		'bitacora',
		'jugada',
		'ultimos',
		'miraObjetivos',
		'miraAfectadas',
		'atacante',
		'fase',
		'proximo',
		'plan',
		'efectos',
		'hoverCoord',
		'hoverLado',
		'sonidoActivo',
		'confirmando',
		'tituloFin',
		'textoFin',
		'finVisible',
		'version',
		'textoResultado',
		'turnoVisto'
	],
	#category : 'BatallaNaval-Grafica',
	#package : 'BatallaNaval-Grafica'
}

{ #category : 'opening' }
ControladorGrafico class >> abrir [
	^ self new abrir
]

{ #category : 'opening' }
ControladorGrafico >> abrir [
	ventana := VentanaBatallaNaval controlador: self.
	self iniciarPartidaContraLaIA.
	ventana abrir
]

{ #category : 'texts' }
ControladorGrafico >> anotar: unTexto estilo: unEstilo [
	bitacora addFirst: unTexto -> unEstilo.
	bitacora size > 40 ifTrue: [ bitacora removeLast ]
]

{ #category : 'accessing' }
ControladorGrafico >> atacante [
	"Solo devuelve la nave atacante si la persona puede saber dónde está (es suya o es la demostración)."
	^ (atacante notNil and: [ self naveVisible: atacante ]) ifTrue: [ atacante ] ifFalse: [ nil ]
]

{ #category : 'accessing' }
ControladorGrafico >> aviso [
	^ aviso
]

{ #category : 'accessing' }
ControladorGrafico >> bitacora [
	^ bitacora
]

{ #category : 'updating' }
ControladorGrafico >> cambio [
	version := version + 1
]

{ #category : 'actions' }
ControladorGrafico >> cancelar [
	objetivos := OrderedCollection new.
	aviso := ''.
	confirmando := nil.
	partida estado = #enCurso ifTrue: [
		seleccion := nil.
		modo := #atacar ].
	self cambio
]

{ #category : 'attack' }
ControladorGrafico >> celdasDe: unaNave objetivos: unosObjetivos dueno: unJugador [
	"Casillas que este disparo va a afectar (se calcula antes de disparar, con el arma del modelo)."
	| tablero afectadas |
	tablero := partida tablero.
	afectadas := [ unaNave arma coordenadasAfectadasPor: unosObjetivos en: tablero rival: (partida rivalDe: unJugador) territorio ]
		on: Error do: [ :error | #() ].
	^ afectadas select: [ :cadaCoordenada |
		(tablero coordenadaValida: cadaCoordenada) and: [ (tablero casillaEn: cadaCoordenada) puedeRecibirDisparo ] ]
]

{ #category : 'testing' }
ControladorGrafico >> chipActivo: unaNave propia: esPropia [
	(demo or: [ esPropia not or: [ bloqueado ] ]) ifTrue: [ ^ false ].
	partida estado = #colocandoNaves ifTrue: [ ^ unaNave estaUbicada not ].
	^ partida estado = #enCurso and: [ partida jugadorActual == self humano and: [ unaNave estaHundida not ] ]
]

{ #category : 'attack' }
ControladorGrafico >> clasificarAtaque: unosResultados celdas: unasCoordenadas [
	| lista |
	lista := OrderedCollection new.
	unasCoordenadas do: [ :cadaCoordenada |
		lista add: cadaCoordenada -> (self tipoDeEfectoEn: (partida tablero casillaEn: cadaCoordenada)) ].
	unosResultados do: [ :cadaResultado |
		(cadaResultado esImpacto and: [ unasCoordenadas noneSatisfy: [ :c | c = cadaResultado coordenada ] ]) ifTrue: [
			lista add: cadaResultado coordenada -> (cadaResultado esHundido ifTrue: [ #hundido ] ifFalse: [ #impacto ]) ] ].
	^ lista
]

{ #category : 'drawing support' }
ControladorGrafico >> columnaDelTorpedoEn: unTerritorio [
	| nave dueno |
	nave := self naveEnCurso.
	(nave isNil or: [ nave estaUbicada not ]) ifTrue: [ ^ nil ].
	nave arma cantidadDeObjetivos = 0 ifFalse: [ ^ nil ].
	dueno := self duenoDe: nave.
	(partida rivalDe: dueno) territorio filaInicial = unTerritorio filaInicial ifFalse: [ ^ nil ].
	^ (dueno territorio origenDe: nave) columna
]

{ #category : 'accessing' }
ControladorGrafico >> confirmando [
	^ confirmando
]

{ #category : 'actions' }
ControladorGrafico >> confirmar: unaClave hacer: unBloque [
	confirmando = unaClave ifTrue: [
		confirmando := nil.
		aviso := ''.
		unBloque value.
		^ self cambio ].
	confirmando := unaClave.
	aviso := 'Tocá otra vez el mismo botón para confirmar.'.
	self cambio
]

{ #category : 'accessing' }
ControladorGrafico >> demo [
	^ demo
]

{ #category : 'actions' }
ControladorGrafico >> despuesDeColocar [
	partida estado = #colocandoNaves
		ifTrue: [ seleccion := self humano navesSinUbicar ifEmpty: [ nil ] ifNotEmpty: [ :naves | naves first ] ]
		ifFalse: [ seleccion := nil ].
	partida estado = #enCurso ifTrue: [ self anotar: '¡Empieza la batalla! Tenés el primer turno.' estilo: #sist ]
]

{ #category : 'state machine' }
ControladorGrafico >> despuesDeJugada [
	atacante := nil.
	plan := nil.
	miraObjetivos := nil.
	miraAfectadas := #().
	partida estaFinalizada ifTrue: [ ^ self terminarPartida ].
	partida jugadorActual esAutomatico
		ifTrue: [
			bloqueado := true.
			self programar: #faseIaInicio en: 700 ]
		ifFalse: [ bloqueado := false ]
]

{ #category : 'actions' }
ControladorGrafico >> disparar [
	self puedeDisparar ifFalse: [ ^ self ].
	aviso := ''.
	self intentar: [ self ejecutarAtaqueHumano ]
]

{ #category : 'accessing' }
ControladorGrafico >> duenoDe: unaNave [
	^ partida jugadores detect: [ :cadaJugador | cadaJugador flota naves includes: unaNave ]
]

{ #category : 'accessing' }
ControladorGrafico >> efectos [
	^ efectos
]

{ #category : 'actions' }
ControladorGrafico >> ejecutarAtaqueHumano [
	| nave lista celdas resultados clasif |
	nave := seleccion.
	lista := objetivos asArray.
	[ celdas := self celdasDe: nave objetivos: lista dueno: self humano.
	resultados := partida atacarCon: nave objetivos: lista ]
		on: ErrorDeBatallaNaval
		do: [ :error |
			objetivos := OrderedCollection new.
			error pass ].
	clasif := self mostrarAtaqueDe: self humano nave: nave celdas: celdas resultados: resultados.
	jugada := JugadaNarrada titulo: 'Tu jugada'.
	jugada agregarPaso: 'Elegiste el ' , nave class name asString , ' de ' , (self origenTextoDe: nave dueno: self humano) , ' con ' , (self nombreDeArma: nave arma) , '.'.
	jugada agregarPaso: (self textoApuntadoDe: nave objetivos: lista dueno: self humano).
	jugada agregarPaso: 'Resultado: ' , textoResultado estilo: #res.
	jugada terminar.
	seleccion := nil.
	objetivos := OrderedCollection new.
	modo := #atacar.
	bloqueado := true.
	self programar: #faseHumanoCerrar en: 1700
]

{ #category : 'actions' }
ControladorGrafico >> elegirNave: unaNave [
	bloqueado ifTrue: [ ^ self ].
	aviso := ''.
	confirmando := nil.
	seleccion := unaNave.
	objetivos := OrderedCollection new.
	modo := #atacar.
	partida estado = #enCurso ifTrue: [ self evaluarSeleccion ].
	self cambio
]

{ #category : 'testing' }
ControladorGrafico >> esColocandoMinas [
	^ demo not and: [ partida estado = #colocandoMinas ]
]

{ #category : 'testing' }
ControladorGrafico >> esColocandoNaves [
	^ demo not and: [ partida estado = #colocandoNaves ]
]

{ #category : 'testing' }
ControladorGrafico >> esTurnoHumano [
	^ demo not and: [ bloqueado not and: [ partida estado = #enCurso and: [ partida jugadorActual == self humano ] ] ]
]

{ #category : 'actions' }
ControladorGrafico >> evaluarSeleccion [
	seleccion puedeAtacar ifTrue: [ ^ self ].
	aviso := seleccion class name asString , ' no puede atacar ahora'
		, (seleccion recargaRestante > 0 ifTrue: [ ' (recarga: ' , seleccion recargaRestante printString , ')' ] ifFalse: [ '' ])
		, '.'.
	self puedeReubicarSeleccion ifTrue: [
		modo := #reubicar.
		aviso := aviso , ' Podés reubicarla.' ]
]

{ #category : 'state machine' }
ControladorGrafico >> falloInterno: unError [
	bloqueado := false.
	fase := nil.
	atacante := nil.
	miraObjetivos := nil.
	miraAfectadas := #().
	aviso := 'Error interno: ' , unError class name asString , ' - ' , (unError messageText ifNil: [ '' ]).
	Transcript crShow: aviso
]

{ #category : 'state machine' }
ControladorGrafico >> faseHumanoCerrar [
	atacante := nil.
	partida estaFinalizada ifFalse: [
		partida jugadorActual == self humano ifTrue: [ aviso := '¡Turno extra! Elegí otra nave.' ] ].
	self despuesDeJugada
]

{ #category : 'state machine' }
ControladorGrafico >> faseIaApuntar [
	| jugador nave |
	jugador := partida jugadorActual.
	nave := plan nave.
	miraObjetivos := plan objetivos asArray.
	miraAfectadas := self celdasDe: nave objetivos: plan objetivos dueno: jugador.
	nave arma cantidadDeObjetivos = 0
		ifTrue: [
			jugada agregarPaso: ((self naveVisible: nave)
				ifTrue: [ 'Apunta por la columna ' , (Character value: 64 + (jugador territorio origenDe: nave) columna) asString , '.' ]
				ifFalse: [ 'Prepara un torpedo.' ]) ]
		ifFalse: [
			jugada agregarPaso: 'Apunta a ' , (', ' join: (plan objetivos collect: [ :cadaCoordenada | cadaCoordenada comoTexto ])) , '.' ].
	self programar: #faseIaDisparar en: 1500
]

{ #category : 'state machine' }
ControladorGrafico >> faseIaCerrar [
	self despuesDeJugada
]

{ #category : 'state machine' }
ControladorGrafico >> faseIaDisparar [
	| jugador nave celdas resultados |
	jugador := partida jugadorActual.
	nave := plan nave.
	celdas := self celdasDe: nave objetivos: plan objetivos dueno: jugador.
	jugador ejecutarPlan: plan en: partida.
	resultados := partida ultimoAtaque isNil ifTrue: [ #() ] ifFalse: [ partida ultimoAtaque last ].
	miraObjetivos := nil.
	miraAfectadas := #().
	self mostrarAtaqueDe: jugador nave: nave celdas: celdas resultados: resultados.
	jugada agregarPaso: 'Dispara.'.
	self programar: #faseIaResolver en: 1700
]

{ #category : 'state machine' }
ControladorGrafico >> faseIaElegir [
	| jugador nave |
	jugador := partida jugadorActual.
	nave := plan nave.
	plan esAtaque ifTrue: [
		atacante := nave.
		jugada agregarPaso: 'Elige el ' , nave class name asString , (self textoOrigenVisibleDe: nave dueno: jugador) , ' con ' , (self nombreDeArma: nave arma) , '.'.
		^ self programar: #faseIaApuntar en: 1200 ].
	plan esReubicacion ifTrue: [
		atacante := nave.
		jugada agregarPaso: 'Ninguna nave puede disparar: reubica el ' , nave class name asString , '.'.
		^ self programar: #faseIaReubicar en: 1200 ].
	jugada agregarPaso: 'No puede disparar ni reubicar: pasa el turno.' estilo: #res.
	self programar: #faseIaPasar en: 1200
]

{ #category : 'state machine' }
ControladorGrafico >> faseIaInicio [
	| jugador esExtra |
	partida estaFinalizada ifTrue: [ ^ self terminarPartida ].
	jugador := partida jugadorActual.
	jugador esAutomatico ifFalse: [ ^ self despuesDeJugada ].
	esExtra := turnoVisto = partida turnosJugados.
	turnoVisto := partida turnosJugados.
	bloqueado := true.
	jugada := JugadaNarrada titulo: (esExtra
		ifTrue: [ 'Turno extra de ' , jugador nombre ]
		ifFalse: [ 'Turno ' , (partida turnosJugados + 1) printString , ': ' , jugador nombre ]).
	jugada agregarPaso: jugador nombre , ' piensa su jugada...'.
	plan := jugador planearTurno: partida.
	self programar: #faseIaElegir en: 900
]

{ #category : 'state machine' }
ControladorGrafico >> faseIaPasar [
	| jugador |
	jugador := partida jugadorActual.
	jugador ejecutarPlan: plan en: partida.
	self anotar: jugador nombre , ': pasó el turno.' estilo: #rival.
	jugada terminar.
	self programar: #faseIaCerrar en: 900
]

{ #category : 'state machine' }
ControladorGrafico >> faseIaResolver [
	jugada agregarPaso: 'Resultado: ' , textoResultado estilo: #res.
	jugada terminar.
	self programar: #faseIaCerrar en: 700
]

{ #category : 'state machine' }
ControladorGrafico >> faseIaReubicar [
	| jugador nave antes mina |
	jugador := partida jugadorActual.
	nave := plan nave.
	antes := nave cantidadDeImpactos.
	jugador ejecutarPlan: plan en: partida.
	jugada agregarPaso: 'Reubicó el ' , nave class name asString , ' en su territorio.' estilo: #res.
	self anotar: jugador nombre , ': reubicó el ' , nave class name asString , '.' estilo: #rival.
	nave cantidadDeImpactos > antes ifTrue: [
		mina := self minaPisadaPor: nave.
		jugada agregarPaso: '¡Pisó una mina!' estilo: #res.
		self anotar: '¡El ' , nave class name asString , ' de ' , jugador nombre , ' pisó una mina!' estilo: #alerta.
		mina notNil ifTrue: [ efectos add: (EfectoVisual tipo: #mina coordenada: mina retraso: 0) ] ].
	jugada terminar.
	self programar: #faseIaCerrar en: 1200
]

{ #category : 'drawing support' }
ControladorGrafico >> filasFueraDeAlcance [
	| nave dueno rivalTerritorio origen alcance |
	nave := self naveEnCurso.
	(nave isNil or: [ nave estaUbicada not or: [ nave estaHundida ] ]) ifTrue: [ ^ #() ].
	(self atacante notNil and: [ plan notNil and: [ plan esAtaque not ] ]) ifTrue: [ ^ #() ].
	dueno := self duenoDe: nave.
	rivalTerritorio := (partida rivalDe: dueno) territorio.
	origen := dueno territorio origenDe: nave.
	alcance := nave arma alcance.
	^ (rivalTerritorio filaInicial to: rivalTerritorio filaFinal) select: [ :fila | (fila - origen fila) abs > alcance ]
]

{ #category : 'accessing' }
ControladorGrafico >> finVisible [
	^ finVisible
]

{ #category : 'attack' }
ControladorGrafico >> frase: unTipo en: unaCoordenada [
	| nave |
	nave := (partida tablero casillaEn: unaCoordenada) nave.
	unTipo = #agua ifTrue: [ ^ 'agua en ' , unaCoordenada comoTexto ].
	unTipo = #isla ifTrue: [ ^ 'isla en ' , unaCoordenada comoTexto ].
	unTipo = #hundido ifTrue: [ ^ '¡hundido el ' , nave class name asString , ' en ' , unaCoordenada comoTexto , '!' ].
	^ 'impacto en ' , unaCoordenada comoTexto , ' (' , nave class name asString , ')'
]

{ #category : 'testing' }
ControladorGrafico >> hayAnimacion [
	^ efectos notEmpty or: [ miraObjetivos notNil or: [ objetivos notEmpty ] ]
]

{ #category : 'events' }
ControladorGrafico >> hover: unaCoordenada de: unLado [
	unaCoordenada isNil
		ifTrue: [
			hoverLado = unLado ifTrue: [
				hoverCoord := nil.
				hoverLado := nil ] ]
		ifFalse: [
			hoverCoord := unaCoordenada.
			hoverLado := unLado ]
]

{ #category : 'accessing' }
ControladorGrafico >> humano [
	^ demo ifTrue: [ nil ] ifFalse: [ partida jugadorHumano ]
]

{ #category : 'starting' }
ControladorGrafico >> iniciarDemo [
	| enJuego |
	enJuego := demo not and: [ partida notNil and: [ partida estaFinalizada not ] ].
	(enJuego and: [ confirmando ~= #demo ]) ifTrue: [
		confirmando := #demo.
		aviso := 'Hay una partida en curso: tocá otra vez para empezar la demostración.'.
		^ self cambio ].
	self reiniciarEstado.
	demo := true.
	partida := Partida entreIAs: azar.
	self anotar: 'Demostración: ' , partida jugadores first nombre , ' juega contra ' , partida jugadores last nombre , '.' estilo: #sist.
	ventana notNil ifTrue: [ ventana partidaNueva ].
	bloqueado := true.
	self programar: #faseIaInicio en: 700.
	self cambio
]

{ #category : 'starting' }
ControladorGrafico >> iniciarPartidaContraLaIA [
	self reiniciarEstado.
	demo := false.
	partida := Partida contraLaIA: 'Vos' azar: azar.
	self anotar: 'Nueva partida contra la computadora.' estilo: #sist.
	ventana notNil ifTrue: [ ventana partidaNueva ].
	self cambio
]

{ #category : 'initialization' }
ControladorGrafico >> initialize [
	super initialize.
	azar := Random new.
	demo := false.
	sonidoActivo := true.
	version := 0.
	self reiniciarEstado
]

{ #category : 'actions' }
ControladorGrafico >> intentar: unBloque [
	"Ejecuta una acción de la persona y muestra en el diario el motivo si el modelo la rechaza."
	[ unBloque value ]
		on: ErrorDeBatallaNaval
		do: [ :error | aviso := error messageText ifNil: [ error description ] ].
	self cambio
]

{ #category : 'accessing' }
ControladorGrafico >> jugada [
	^ jugada
]

{ #category : 'drawing support' }
ControladorGrafico >> matrizVisible [
	^ demo
		ifTrue: [ partida tablero vistaCompleta ]
		ifFalse: [ partida tablero vistaPara: self humano territorio ]
]

{ #category : 'actions' }
ControladorGrafico >> minaPisadaPor: unaNave [
	^ unaNave posiciones
		detect: [ :cadaCoordenada |
			| casilla |
			casilla := partida tablero casillaEn: cadaCoordenada.
			casilla tieneMina and: [ casilla terreno explotada ] ]
		ifNone: [ nil ]
]

{ #category : 'actions' }
ControladorGrafico >> minasAlAzar [
	self intentar: [
		partida ubicarMinasAlAzar.
		self anotar: 'Sembraste tus minas al azar.' estilo: #mia.
		self despuesDeColocar ]
]

{ #category : 'accessing' }
ControladorGrafico >> miraAfectadas [
	^ miraAfectadas
]

{ #category : 'accessing' }
ControladorGrafico >> miraObjetivos [
	^ miraObjetivos
]

{ #category : 'accessing' }
ControladorGrafico >> modo [
	^ modo
]

{ #category : 'actions' }
ControladorGrafico >> modoAtacar [
	modo := #atacar.
	objetivos := OrderedCollection new.
	aviso := ''.
	self cambio
]

{ #category : 'actions' }
ControladorGrafico >> modoReubicar [
	self puedeReubicarSeleccion ifTrue: [
		modo := #reubicar.
		objetivos := OrderedCollection new.
		aviso := '' ].
	self cambio
]

{ #category : 'attack' }
ControladorGrafico >> mostrarAtaqueDe: unJugador nave: unaNave celdas: unasCeldas resultados: unosResultados [
	"Arma los efectos, la bitácora y el texto del resultado. Devuelve la clasificación de casillas."
	| clasif territorioRival deAbajo retraso estilo |
	territorioRival := (partida rivalDe: unJugador) territorio.
	deAbajo := unJugador territorio filaInicial > territorioRival filaInicial.
	clasif := self clasificarAtaque: unosResultados celdas: unasCeldas.
	ultimos := clasif collect: [ :a | a key ].
	atacante := unaNave.
	retraso := 650.
	unaNave arma cantidadDeObjetivos = 0
		ifTrue: [
			retraso := 750.
			efectos add: (EfectoVisual
				estela: (unJugador territorio origenDe: unaNave) columna
				territorio: territorioRival deAbajo: deAbajo duracion: 700) ]
		ifFalse: [
			clasif do: [ :a |
				efectos add: (EfectoVisual proyectil: a key deAbajo: deAbajo retraso: 0 duracion: 650) ] ].
	clasif do: [ :a | efectos add: (EfectoVisual tipo: a value coordenada: a key retraso: retraso) ].
	textoResultado := self resumenDe: clasif resultados: unosResultados.
	estilo := (clasif anySatisfy: [ :a | a value = #hundido ])
		ifTrue: [ #alerta ]
		ifFalse: [ unJugador esAutomatico ifTrue: [ #rival ] ifFalse: [ #mia ] ].
	self anotar: unJugador nombre , ': ' , unaNave class name asString , ' - ' , textoResultado , '.' estilo: estilo.
	self sonarCon: clasif.
	^ clasif
]

{ #category : 'drawing support' }
ControladorGrafico >> naveEnCurso [
	"La nave cuyo alcance se muestra: la que apunta la computadora (solo si es visible) o la elegida por la persona."
	self atacante notNil ifTrue: [ ^ self atacante ].
	^ (self esTurnoHumano and: [ modo = #atacar ]) ifTrue: [ seleccion ] ifFalse: [ nil ]
]

{ #category : 'texts' }
ControladorGrafico >> naveParaPie: unLado [
	| casilla |
	(hoverLado = unLado and: [ hoverCoord notNil ]) ifTrue: [
		casilla := partida tablero casillaEn: hoverCoord.
		(casilla nave notNil and: [ demo or: [ unLado = #propio or: [ casilla estaRevelada ] ] ])
			ifTrue: [ ^ casilla nave ] ].
	^ (unLado = #propio and: [ demo not ]) ifTrue: [ seleccion ] ifFalse: [ nil ]
]

{ #category : 'accessing' }
ControladorGrafico >> naveVisible: unaNave [
	"Las naves de la computadora no se señalan ni se ubican en pantalla durante una partida contra la persona."
	^ demo or: [ (self duenoDe: unaNave) == self humano ]
]

{ #category : 'actions' }
ControladorGrafico >> navesAlAzar [
	self intentar: [
		partida ubicarNavesAlAzar.
		self anotar: 'Ubicaste tus naves al azar.' estilo: #mia.
		self despuesDeColocar ]
]

{ #category : 'texts' }
ControladorGrafico >> nombreDeArma: unaArma [
	^ ({ #Canion -> 'Cañón'. #CanionTurbo -> 'Cañón turbo'. #BombardeoAereo -> 'Bombardeo aéreo'. #Torpedo -> 'Torpedo'. #TorpedoHorizontal -> 'Torpedo horizontal' } asDictionary)
		at: unaArma class name asSymbol
		ifAbsent: [ unaArma class name asString ]
]

{ #category : 'starting' }
ControladorGrafico >> nuevaPartida [
	(demo or: [ partida estaFinalizada ]) ifTrue: [ ^ self iniciarPartidaContraLaIA ].
	self confirmar: #nueva hacer: [ self iniciarPartidaContraLaIA ]
]

{ #category : 'accessing' }
ControladorGrafico >> objetivos [
	^ objetivos
]

{ #category : 'actions' }
ControladorGrafico >> ocultarFin [
	finVisible := false.
	self cambio
]

{ #category : 'accessing' }
ControladorGrafico >> orientacion [
	^ orientacion
]

{ #category : 'texts' }
ControladorGrafico >> origenTextoDe: unaNave dueno: unJugador [
	^ (unJugador territorio origenDe: unaNave) comoTexto
]

{ #category : 'accessing' }
ControladorGrafico >> partida [
	^ partida
]

{ #category : 'actions' }
ControladorGrafico >> pasarTurnoHumano [
	self puedePasar ifFalse: [ ^ self ].
	self intentar: [
		partida pasarTurno.
		self anotar: 'Pasaste el turno.' estilo: #mia.
		jugada := JugadaNarrada titulo: 'Tu jugada'.
		jugada agregarPaso: 'Pasaste el turno.' estilo: #res.
		jugada terminar.
		seleccion := nil.
		objetivos := OrderedCollection new.
		modo := #atacar.
		self despuesDeJugada ]
]

{ #category : 'state machine' }
ControladorGrafico >> paso [
	| ahora antes siguiente |
	ahora := Time millisecondClockValue.
	antes := efectos size.
	efectos := (efectos reject: [ :cadaEfecto | cadaEfecto vencido: ahora ]) asOrderedCollection.
	efectos size = antes ifFalse: [ self cambio ].
	(fase notNil and: [ ahora >= proximo ]) ifTrue: [
		siguiente := fase.
		fase := nil.
		[ self perform: siguiente ]
			on: Error
			do: [ :error | self falloInterno: error ].
		self cambio ]
]

{ #category : 'drawing support' }
ControladorGrafico >> previaDe: unLado en: unaCoordenada [
	"Colecciones de asociaciones coordenada -> es valida, para dibujar bajo el puntero."
	(bloqueado or: [ demo ]) ifTrue: [ ^ #() ].
	self esColocandoMinas ifTrue: [
		^ unLado = #rival ifTrue: [ { unaCoordenada -> true } ] ifFalse: [ #() ] ].
	self esColocandoNaves ifTrue: [
		^ (unLado = #propio and: [ seleccion notNil ])
			ifTrue: [ self previaDeUbicacionDe: seleccion en: unaCoordenada ]
			ifFalse: [ #() ] ].
	(self esTurnoHumano and: [ seleccion notNil ]) ifFalse: [ ^ #() ].
	(modo = #reubicar and: [ unLado = #propio ]) ifTrue: [ ^ self previaDeUbicacionDe: seleccion en: unaCoordenada ].
	(modo = #atacar and: [ unLado = #rival ]) ifTrue: [ ^ self previaDeAtaqueEn: unaCoordenada ].
	^ #()
]

{ #category : 'drawing support' }
ControladorGrafico >> previaDeAtaqueEn: unaCoordenada [
	| arma lista |
	arma := seleccion arma.
	(arma cantidadDeObjetivos = 0 or: [ objetivos size >= arma cantidadDeObjetivos ]) ifTrue: [ ^ #() ].
	lista := (objetivos copyWith: unaCoordenada) asArray.
	lista size = arma cantidadDeObjetivos ifFalse: [ ^ { unaCoordenada -> true } ].
	^ ([ arma coordenadasAfectadasPor: lista en: partida tablero rival: (partida rivalDe: self humano) territorio ]
		on: Error do: [ :error | { unaCoordenada } ])
		collect: [ :cadaCoordenada | cadaCoordenada -> true ]
]

{ #category : 'drawing support' }
ControladorGrafico >> previaDeUbicacionDe: unaNave en: unaCoordenada [
	| coordenadas valido |
	coordenadas := [ partida tablero coordenadasDe: unaNave desde: unaCoordenada orientacion: orientacion ]
		on: ErrorDeBatallaNaval do: [ :error | ^ #() ].
	valido := [ partida tablero validarUbicacion: coordenadas en: self humano territorio ignorando: unaNave. true ]
		on: ErrorDeBatallaNaval do: [ :error | false ].
	^ coordenadas collect: [ :cadaCoordenada | cadaCoordenada -> valido ]
]

{ #category : 'actions' }
ControladorGrafico >> procesarToque: unaCoordenada en: unLado [
	partida estado = #colocandoMinas ifTrue: [ ^ self tocarMinaEn: unaCoordenada en: unLado ].
	partida estado = #colocandoNaves ifTrue: [ ^ self tocarUbicacionEn: unaCoordenada en: unLado ].
	partida estado = #enCurso ifFalse: [ ^ self ].
	partida jugadorActual == self humano ifFalse: [ ^ self ].
	^ unLado = #propio
		ifTrue: [ self tocarPropioEnCurso: unaCoordenada ]
		ifFalse: [ self tocarRival: unaCoordenada ]
]

{ #category : 'state machine' }
ControladorGrafico >> programar: unSelector en: unosMilisegundos [
	fase := unSelector.
	proximo := Time millisecondClockValue + unosMilisegundos
]

{ #category : 'accessing' }
ControladorGrafico >> propietarioDe: unLado [
	^ unLado = #propio
		ifTrue: [ partida jugadores first ]
		ifFalse: [ partida jugadores last ]
]

{ #category : 'testing' }
ControladorGrafico >> puedeCancelar [
	^ self esTurnoHumano and: [ seleccion notNil ]
]

{ #category : 'testing' }
ControladorGrafico >> puedeDisparar [
	^ self esTurnoHumano and: [
		seleccion notNil and: [
			modo = #atacar and: [
				seleccion puedeAtacar and: [ objetivos size = seleccion arma cantidadDeObjetivos ] ] ] ]
]

{ #category : 'testing' }
ControladorGrafico >> puedeMinasAlAzar [
	^ bloqueado not and: [ self esColocandoMinas ]
]

{ #category : 'testing' }
ControladorGrafico >> puedeModoAtacar [
	^ self esTurnoHumano and: [ seleccion notNil and: [ seleccion puedeAtacar ] ]
]

{ #category : 'testing' }
ControladorGrafico >> puedeModoReubicar [
	^ self puedeReubicarSeleccion
]

{ #category : 'testing' }
ControladorGrafico >> puedeNavesAlAzar [
	^ bloqueado not and: [ self esColocandoNaves ]
]

{ #category : 'testing' }
ControladorGrafico >> puedePasar [
	^ self esTurnoHumano
]

{ #category : 'testing' }
ControladorGrafico >> puedeReubicarSeleccion [
	^ seleccion notNil and: [
		self esTurnoHumano and: [
			seleccion estaUbicada and: [
				seleccion
					puedeReubicarseDesde: (self humano territorio origenDe: seleccion)
					contra: partida tablero
					rival: (partida rivalDe: self humano) territorio ] ] ]
]

{ #category : 'testing' }
ControladorGrafico >> puedeRotar [
	^ bloqueado not and: [
		demo not and: [
			self esColocandoNaves or: [ modo = #reubicar and: [ seleccion notNil and: [ self esTurnoHumano ] ] ] ] ]
]

{ #category : 'testing' }
ControladorGrafico >> puedeTerminar [
	^ partida notNil and: [ partida estado = #enCurso ]
]

{ #category : 'initialization' }
ControladorGrafico >> reiniciarEstado [
	seleccion := nil.
	modo := #atacar.
	orientacion := #horizontal.
	objetivos := OrderedCollection new.
	bloqueado := false.
	aviso := ''.
	bitacora := OrderedCollection new.
	jugada := nil.
	ultimos := #().
	miraObjetivos := nil.
	miraAfectadas := #().
	atacante := nil.
	fase := nil.
	proximo := 0.
	plan := nil.
	efectos := OrderedCollection new.
	hoverCoord := nil.
	hoverLado := nil.
	confirmando := nil.
	finVisible := false.
	tituloFin := ''.
	textoFin := ''.
	textoResultado := ''.
	turnoVisto := nil
]

{ #category : 'attack' }
ControladorGrafico >> resumenDe: unaClasificacion resultados: unosResultados [
	| partes |
	partes := OrderedCollection new.
	unaClasificacion do: [ :a | partes add: (self frase: a value en: a key) ].
	unaClasificacion isEmpty ifTrue: [
		(unosResultados anySatisfy: [ :r | r esBloqueado ])
			ifTrue: [ partes add: 'choca contra una isla' ]
			ifFalse: [ partes add: 'se pierde en el agua' ] ].
	^ ', ' join: partes
]

{ #category : 'actions' }
ControladorGrafico >> reubicarEn: unaCoordenada [
	| nave antes mina |
	nave := seleccion.
	antes := nave cantidadDeImpactos.
	partida reubicar: nave desde: unaCoordenada orientacion: orientacion.
	jugada := JugadaNarrada titulo: 'Tu jugada'.
	jugada agregarPaso: 'Reubicaste el ' , nave class name asString , ' en ' , unaCoordenada comoTexto , '.' estilo: #res.
	self anotar: 'Reubicaste el ' , nave class name asString , ' en ' , unaCoordenada comoTexto , '.' estilo: #mia.
	nave cantidadDeImpactos > antes ifTrue: [
		mina := self minaPisadaPor: nave.
		jugada agregarPaso: '¡Pisó una mina!' estilo: #res.
		self anotar: '¡El ' , nave class name asString , ' pisó una mina!' estilo: #alerta.
		mina notNil ifTrue: [ efectos add: (EfectoVisual tipo: #mina coordenada: mina retraso: 0) ] ].
	jugada terminar.
	seleccion := nil.
	objetivos := OrderedCollection new.
	modo := #atacar.
	bloqueado := true.
	self programar: #faseHumanoCerrar en: 1000
]

{ #category : 'actions' }
ControladorGrafico >> rotar [
	orientacion := orientacion = #horizontal ifTrue: [ #vertical ] ifFalse: [ #horizontal ].
	self cambio
]

{ #category : 'texts' }
ControladorGrafico >> rotuloDemo [
	^ confirmando = #demo ifTrue: [ '¿Seguro?' ] ifFalse: [ 'Demo IA vs IA' ]
]

{ #category : 'texts' }
ControladorGrafico >> rotuloNueva [
	^ confirmando = #nueva ifTrue: [ '¿Seguro?' ] ifFalse: [ 'Nueva partida' ]
]

{ #category : 'texts' }
ControladorGrafico >> rotuloTerminar [
	^ confirmando = #terminar ifTrue: [ '¿Seguro?' ] ifFalse: [ 'Terminar' ]
]

{ #category : 'accessing' }
ControladorGrafico >> seleccion [
	^ seleccion
]

{ #category : 'actions' }
ControladorGrafico >> terminarJuego [
	self puedeTerminar ifFalse: [ ^ self ].
	self confirmar: #terminar hacer: [
		fase := nil.
		partida terminarPorTiempo.
		self terminarPartida ]
]

{ #category : 'state machine' }
ControladorGrafico >> terminarPartida [
	| ganador primero ultimo |
	fase := nil.
	bloqueado := false.
	atacante := nil.
	plan := nil.
	miraObjetivos := nil.
	miraAfectadas := #().
	seleccion := nil.
	objetivos := OrderedCollection new.
	jugada notNil ifTrue: [ jugada terminar ].
	ganador := partida ganador.
	primero := partida jugadores first.
	ultimo := partida jugadores last.
	tituloFin := ganador isNil
		ifTrue: [ 'Empate' ]
		ifFalse: [
			demo
				ifTrue: [ 'Ganó ' , ganador nombre ]
				ifFalse: [ ganador == self humano ifTrue: [ '¡Ganaste!' ] ifFalse: [ 'Perdiste' ] ] ].
	textoFin := 'Naves hundidas por ' , primero nombre , ': ' , (partida navesHundidasPor: primero) printString
		, '. Por ' , ultimo nombre , ': ' , (partida navesHundidasPor: ultimo) printString
		, '. Turnos jugados: ' , partida turnosJugados printString , '.'.
	finVisible := true.
	self anotar: tituloFin , '. ' , textoFin estilo: #alerta
]

{ #category : 'accessing' }
ControladorGrafico >> territorioDe: unLado [
	^ (self propietarioDe: unLado) territorio
]

{ #category : 'texts' }
ControladorGrafico >> textoApuntadoDe: unaNave objetivos: unosObjetivos dueno: unJugador [
	unaNave arma cantidadDeObjetivos = 0 ifTrue: [
		^ 'Disparaste por la columna ' , (Character value: 64 + (unJugador territorio origenDe: unaNave) columna) asString , '.' ].
	^ 'Apuntaste a ' , (', ' join: (unosObjetivos collect: [ :cadaCoordenada | cadaCoordenada comoTexto ])) , '.'
]

{ #category : 'texts' }
ControladorGrafico >> textoDeNave: unaNave [
	^ unaNave class name asString , ' (tamaño ' , unaNave tamano printString , '). Arma: '
		, (self nombreDeArma: unaNave arma) , ', alcance ' , unaNave arma alcance printString
		, ', objetivos ' , unaNave arma cantidadDeObjetivos printString , '.'
		, (unaNave recargaRestante > 0 ifTrue: [ ' Recarga: ' , unaNave recargaRestante printString , '.' ] ifFalse: [ '' ])
]

{ #category : 'texts' }
ControladorGrafico >> textoFase [
	partida isNil ifTrue: [ ^ '' ].
	partida estaFinalizada ifTrue: [ ^ 'Partida terminada' ].
	partida estado = #colocandoMinas ifTrue: [ ^ 'Preparación: minas' ].
	partida estado = #colocandoNaves ifTrue: [ ^ 'Preparación: naves' ].
	^ 'Turno ' , (partida turnosJugados + 1) printString , ' - juega ' , partida jugadorActual nombre
]

{ #category : 'texts' }
ControladorGrafico >> textoFicha [
	^ (demo or: [ seleccion isNil ]) ifTrue: [ '' ] ifFalse: [ self textoDeNave: seleccion ]
]

{ #category : 'accessing' }
ControladorGrafico >> textoFin [
	^ textoFin
]

{ #category : 'texts' }
ControladorGrafico >> textoInstruccion [
	partida isNil ifTrue: [ ^ '' ].
	demo ifTrue: [ ^ partida estaFinalizada ifTrue: [ 'La demostración terminó.' ] ifFalse: [ 'Mirá cómo juegan las dos computadoras.' ] ].
	partida estaFinalizada ifTrue: [ ^ 'Fin de la partida.' ].
	partida estado = #colocandoMinas ifTrue: [
		^ 'Sembrá tus minas en el campo enemigo (' , self humano minasRestantes printString , ' restantes) tocando casillas del tablero de la derecha.' ].
	partida estado = #colocandoNaves ifTrue: [
		^ 'Elegí una nave sin ubicar en la tabla y tocá tu tablero. Rotar cambia la orientación (' , orientacion , ').' ].
	bloqueado ifTrue: [
		^ partida jugadorActual esAutomatico
			ifTrue: [ 'Juega ' , partida jugadorActual nombre , '...' ]
			ifFalse: [ 'Resolviendo tu jugada...' ] ].
	modo = #reubicar ifTrue: [ ^ 'Tocá la casilla de tu territorio donde querés reubicar la nave.' ].
	seleccion isNil ifTrue: [ ^ 'Tu turno: elegí una nave tocándola en la tabla o en tu tablero.' ].
	seleccion arma cantidadDeObjetivos = 0 ifTrue: [ ^ 'Esta arma sale por su columna: presioná ¡Fuego!.' ].
	^ 'Tocá ' , (seleccion arma cantidadDeObjetivos - objetivos size) printString , ' casilla(s) del campo enemigo.'
]

{ #category : 'texts' }
ControladorGrafico >> textoOrigenVisibleDe: unaNave dueno: unJugador [
	^ (self naveVisible: unaNave)
		ifTrue: [ ' de ' , (self origenTextoDe: unaNave dueno: unJugador) ]
		ifFalse: [ '' ]
]

{ #category : 'texts' }
ControladorGrafico >> textoPieDe: unLado [
	| nave |
	partida isNil ifTrue: [ ^ '' ].
	nave := self naveParaPie: unLado.
	nave notNil ifTrue: [
		^ nave class name asString , (nave estaHundida ifTrue: [ ' (hundida)' ] ifFalse: [ '' ]) ].
	^ (hoverLado = unLado and: [ hoverCoord notNil ])
		ifTrue: [ hoverCoord comoTexto ]
		ifFalse: [ '' ]
]

{ #category : 'attack' }
ControladorGrafico >> tipoDeEfectoEn: unaCasilla [
	"Qué pasó en la casilla después del disparo, mirando el tablero (el agua no trae coordenada en los resultados)"
	unaCasilla terreno esIsla ifTrue: [ ^ unaCasilla estaRevelada ifTrue: [ #isla ] ifFalse: [ #agua ] ].
	(unaCasilla estaAtacada and: [ unaCasilla nave notNil ]) ifFalse: [ ^ #agua ].
	^ unaCasilla nave estaHundida ifTrue: [ #hundido ] ifFalse: [ #impacto ]
]

{ #category : 'texts' }
ControladorGrafico >> tituloDe: unLado [
	| dueno nombre |
	partida isNil ifTrue: [ ^ '' ].
	dueno := self propietarioDe: unLado.
	nombre := demo
		ifTrue: [ dueno nombre ]
		ifFalse: [ unLado = #propio ifTrue: [ 'Tu territorio' ] ifFalse: [ 'Territorio enemigo' ] ].
	^ nombre , ' (filas ' , dueno territorio filaInicial printString , ' a ' , dueno territorio filaFinal printString , ')'
]

{ #category : 'accessing' }
ControladorGrafico >> tituloFin [
	^ tituloFin
]

{ #category : 'actions' }
ControladorGrafico >> tocarCoordenada: unaCoordenada en: unLado [
	(bloqueado or: [ demo or: [ finVisible or: [ partida estaFinalizada ] ] ]) ifTrue: [ ^ self ].
	aviso := ''.
	confirmando := nil.
	self intentar: [ self procesarToque: unaCoordenada en: unLado ]
]

{ #category : 'actions' }
ControladorGrafico >> tocarMinaEn: unaCoordenada en: unLado [
	unLado = #rival ifFalse: [ ^ aviso := 'Las minas se siembran en el campo enemigo (tablero de la derecha).' ].
	partida ubicarMinaEn: unaCoordenada.
	self anotar: 'Sembraste una mina en ' , unaCoordenada comoTexto , '.' estilo: #mia.
	self despuesDeColocar
]

{ #category : 'actions' }
ControladorGrafico >> tocarPropioEnCurso: unaCoordenada [
	| nave |
	nave := (partida tablero casillaEn: unaCoordenada) nave.
	(nave notNil and: [ nave ~~ seleccion ]) ifTrue: [ ^ self elegirNave: nave ].
	(modo = #reubicar and: [ seleccion notNil ]) ifTrue: [ ^ self reubicarEn: unaCoordenada ].
	nave isNil ifTrue: [ ^ aviso := 'Ahí no hay ninguna nave tuya.' ].
	^ self elegirNave: nave
]

{ #category : 'actions' }
ControladorGrafico >> tocarRival: unaCoordenada [
	| arma |
	seleccion isNil ifTrue: [ ^ aviso := 'Primero elegí una nave (en la tabla o en tu tablero).' ].
	modo = #reubicar ifTrue: [ ^ aviso := 'Estás reubicando: tocá una casilla de tu territorio.' ].
	seleccion puedeAtacar ifFalse: [ ^ aviso := 'Esa nave no puede atacar ahora.' ].
	arma := seleccion arma.
	arma cantidadDeObjetivos = 0 ifTrue: [ ^ aviso := 'Esta arma sale por su columna: presioná ¡Fuego!.' ].
	(objetivos includes: unaCoordenada) ifTrue: [ ^ objetivos remove: unaCoordenada ].
	(partida tablero casillaEn: unaCoordenada) estaAtacada ifTrue: [ ^ aviso := 'Esa casilla ya fue atacada.' ].
	objetivos add: unaCoordenada.
	objetivos size = arma cantidadDeObjetivos ifTrue: [ self ejecutarAtaqueHumano ]
]

{ #category : 'actions' }
ControladorGrafico >> tocarUbicacionEn: unaCoordenada en: unLado [
	unLado = #propio ifFalse: [ ^ aviso := 'Las naves se ubican en tu territorio (tablero de la izquierda).' ].
	seleccion isNil ifTrue: [ ^ aviso := 'Elegí primero una nave sin ubicar en la tabla de abajo.' ].
	partida ubicarNave: seleccion desde: unaCoordenada orientacion: orientacion.
	self anotar: 'Ubicaste el ' , seleccion class name asString , ' en ' , unaCoordenada comoTexto , '.' estilo: #mia.
	self despuesDeColocar
]

{ #category : 'accessing' }
ControladorGrafico >> ultimos [
	^ ultimos
]

{ #category : 'accessing' }
ControladorGrafico >> version [
	^ version
]
