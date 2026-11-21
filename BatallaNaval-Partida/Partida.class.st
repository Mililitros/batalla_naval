"
Controla el ciclo de vida del juego, las fases de preparación, la alternancia de turnos, el límite de tiempo/turnos y la determinación del ganador

"
Class {
	#name : 'Partida',
	#superclass : 'Object',
	#instVars : [
		'tablero',
		'jugadores',
		'jugadorActual',
		'estado',
		'turnoExtraEnCurso',
		'turnosJugados',
		'turnosMaximosPorJugador',
		'azar'
	],
	#category : 'BatallaNaval-Partida',
	#package : 'BatallaNaval-Partida'
}

{ #category : 'as yet unclassified' }
Partida class >> contraLaIA: unNombre azar: unRandom [
    ^ self jugadores: {
        Jugador nombre: unNombre territorio: Territorio inferior.
        JugadorIA nombre: 'Computadora' territorio: Territorio superior azar: unRandom }
        azar: unRandom
]

{ #category : 'instance creation' }
Partida class >> entreIAs: unRandom [
    ^ self jugadores: {
        JugadorIA nombre: 'IA 1' territorio: Territorio inferior azar: unRandom.
        JugadorIA nombre: 'IA 2' territorio: Territorio superior azar: unRandom }
        azar: unRandom
]

{ #category : 'instance creation' }
Partida class >> jugadores: unosJugadores azar: unRandom [
    ^ self new setJugadores: unosJugadores azar: unRandom; iniciar; yourself
]

{ #category : 'accessing' }
Partida >> atacarCon: unaNave objetivos: unasCoordenadas [
    | resultados |
    self validarEstado: #enCurso.
    self validarNave: unaNave.
    resultados := unaNave
        atacar: unasCoordenadas
        desde: (jugadorActual territorio origenDe: unaNave)
        contra: tablero
        rival: self jugadorRival territorio.
    self registrarAtaqueDe: unaNave resultados: resultados.
    ^ resultados
]

{ #category : 'private' }
Partida >> avanzarFaseSiCorresponde [
    | humanos |
    humanos := jugadores reject: [ :cadaJugador | cadaJugador esAutomatico ].
    (estado = #colocandoMinas
        and: [ humanos allSatisfy: [ :cadaJugador | cadaJugador minasRestantes = 0 ] ])
        ifTrue: [ estado := #colocandoNaves ].
    (estado = #colocandoNaves
        and: [ humanos allSatisfy: [ :cadaJugador | cadaJugador navesSinUbicar isEmpty ] ])
        ifTrue: [ self comenzarJuego ]

]

{ #category : 'accessing' }
Partida >> cambiarJugador [
    jugadorActual := self jugadorRival.
    jugadorActual avanzarRecargas.
    self jugadorActualPuedeActuar ifFalse: [ self terminarTurno ]

]

{ #category : 'private' }
Partida >> comenzarJuego [
    jugadores do: [ :cadaJugador |
        cadaJugador esAutomatico ifTrue: [ cadaJugador prepararNavesEn: tablero ] ].
    estado := #enCurso.
    jugadorActual := jugadores first
]

{ #category : 'testing' }
Partida >> esEmpate [
    ^ self estaFinalizada and: [ self ganador isNil ]
]

{ #category : 'testing' }
Partida >> estaFinalizada [
    ^ estado = #finalizada

]

{ #category : 'accessing' }
Partida >> estado [ 
	^estado
]

{ #category : 'accessing' }
Partida >> ganador [
    | primero segundo |
    self estaFinalizada ifFalse: [ ^ nil ].
    primero := jugadores first.
    segundo := jugadores last.
    (self navesHundidasPor: primero) > (self navesHundidasPor: segundo) ifTrue: [ ^ primero ].
    (self navesHundidasPor: segundo) > (self navesHundidasPor: primero) ifTrue: [ ^ segundo ].
    ^ nil

]

{ #category : 'testing' }
Partida >> hayGanador [
    ^ self ganador notNil

]

{ #category : 'initialization' }
Partida >> iniciar [

    jugadores do: [ :cadaJugador |
        tablero
            generarIslas: ((2 to: 3) atRandom: azar)
            en: cadaJugador territorio
            azar: azar ].
    jugadores do: [ :cadaJugador |
        cadaJugador esAutomatico ifTrue: [
            cadaJugador
                prepararMinasEn: tablero
                contra: (self rivalDe: cadaJugador) territorio ] ].
    estado := #colocandoMinas.
    self avanzarFaseSiCorresponde

]

{ #category : 'accessing' }
Partida >> jugadorActual [
	^jugadorActual 
]

{ #category : 'accessing' }
Partida >> jugadorActualPuedeActuar [
    ^ jugadorActual navesOperativas anySatisfy: [ :cadaNave |
        | origen rival |
        origen := jugadorActual territorio origenDe: cadaNave.
        rival := self jugadorRival territorio.
        (cadaNave puedeAtacar and: [ cadaNave puedeAlcanzarAlgoDesde: origen contra: rival ])
            or: [ cadaNave puedeReubicarseDesde: origen contra: tablero rival: rival ] ]
]

{ #category : 'accessing' }
Partida >> jugadorHumano [
    ^ jugadores detect: [ :cadaJugador | cadaJugador esAutomatico not ] ifNone: [ nil ]


]

{ #category : 'accessing' }
Partida >> jugadorRival [
    ^ self rivalDe: jugadorActual

]

{ #category : 'accessing' }
Partida >> navesHundidasPor: unJugador [
    ^ (self rivalDe: unJugador) flota cantidadDeNavesHundidas


]

{ #category : 'accessing' }
Partida >> pasarTurno [
    self validarEstado: #enCurso.
    self terminarTurno
]

{ #category : 'accessing' }
Partida >> registrarAtaqueDe: unaNave resultados: unosResultados [
    | darTurnoExtra |
    self jugadorRival perdio ifTrue: [ estado := #finalizada. ^ self ].
    darTurnoExtra := (unaNave concedeTurnoExtraTras: unosResultados)
        and: [ turnoExtraEnCurso not ].
    darTurnoExtra
        ifTrue: [ turnoExtraEnCurso := true ]
        ifFalse: [ self terminarTurno ]
]

{ #category : 'accessing' }
Partida >> reubicar: unaNave desde: unaCoordenada orientacion: unaOrientacion [
    self validarEstado: #enCurso.
    self validarNave: unaNave.
    (unaNave
        puedeReubicarseDesde: (jugadorActual territorio origenDe: unaNave)
        contra: tablero
        rival: self jugadorRival territorio)
        ifFalse: [ ^ AccionFueraDeTurno new signal: 'La nave no cumple las condiciones para reubicarse' ].
    tablero reubicarNave: unaNave desde: unaCoordenada orientacion: unaOrientacion en: jugadorActual territorio.
    self terminarTurno
]

{ #category : 'accessing' }
Partida >> rivalDe: unJugador [
    ^ jugadores detect: [ :cadaJugador | cadaJugador ~~ unJugador ]

]

{ #category : 'initialization' }
Partida >> setJugadores: unosJugadores azar: unRandom [

    jugadores := unosJugadores.
    azar := unRandom.
    tablero := Tablero estandar.
    estado := #preparando.
    turnoExtraEnCurso := false.
    turnosJugados := 0.
    turnosMaximosPorJugador := 30

]

{ #category : 'accessing' }
Partida >> tablero [
    ^ tablero

]

{ #category : 'actions' }
Partida >> terminarPorTiempo [
    estado = #enCurso ifTrue: [ estado := #finalizada ]
]

{ #category : 'accessing' }
Partida >> terminarTurno [
    turnoExtraEnCurso := false.
    turnosJugados := turnosJugados + 1.
    turnosJugados >= (turnosMaximosPorJugador * jugadores size)
        ifTrue: [ estado := #finalizada ]
        ifFalse: [ self cambiarJugador ]

]

{ #category : 'accessing' }
Partida >> turnosJugados [
	^turnosJugados
]

{ #category : 'accessing' }
Partida >> turnosMaximosPorJugador: unaCantidad [
    turnosMaximosPorJugador := unaCantidad

]

{ #category : 'actions' }
Partida >> ubicarMinaEn: unaCoordenada [
    | humano |
    self validarEstado: #colocandoMinas.
    humano := self jugadorHumano.
    tablero ubicarMinaEn: unaCoordenada en: (self rivalDe: humano) territorio.
    humano usarMina.
    self avanzarFaseSiCorresponde
]

{ #category : 'actions' }
Partida >> ubicarNave: unaNave desde: unaCoordenada orientacion: unaOrientacion [
    | humano |
    self validarEstado: #colocandoNaves.
    humano := self jugadorHumano.
    tablero ubicarNave: unaNave desde: unaCoordenada orientacion: unaOrientacion en: humano territorio.
    self avanzarFaseSiCorresponde
]

{ #category : 'validating' }
Partida >> validarEstado: unEstado [
    estado = unEstado
        ifFalse: [ ^ AccionFueraDeTurno new
            signal: 'Esa acción no corresponde a la fase actual (', estado printString, ')' ]
]

{ #category : 'accessing' }
Partida >> validarNave: unaNave [
    (jugadorActual flota naves identityIncludes: unaNave)
        ifFalse: [ ^ AccionFueraDeTurno new signal: 'La nave no pertenece al jugador actual' ]
]
