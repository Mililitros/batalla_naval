"
Subclase de Jugador que toma decisiones automáticas de preparación, ataque (con modo remate) y reubicación 

"
Class {
	#name : 'JugadorIA',
	#superclass : 'Jugador',
	#instVars : [
		'azar',
		'ultimoImpacto'
	],
	#category : 'BatallaNaval-Partida',
	#package : 'BatallaNaval-Partida'
}

{ #category : 'instance creation' }
JugadorIA class >> nombre: unNombre territorio: unTerritorio azar: unRandom [
    ^ (self nombre: unNombre territorio: unTerritorio) setAzar: unRandom

]

{ #category : 'private' }
JugadorIA >> coordenadasDisponiblesDesde: unOrigen alcance: unAlcance en: unTablero rival: unTerritorio [
    | resultado |
    resultado := OrderedCollection new.
    unTerritorio filaInicial to: unTerritorio filaFinal do: [ :fila |
        (fila - unOrigen fila) abs <= unAlcance ifTrue: [
            1 to: unTablero columnas do: [ :columna |
                | coordenada |
                coordenada := Coordenada fila: fila columna: columna.
                (unTablero casillaEn: coordenada) estaRevelada
                    ifFalse: [ resultado add: coordenada ] ] ] ].
    ^ resultado
]

{ #category : 'private' }
JugadorIA >> elegirObjetivosPara: unaNave en: unTablero rival: unTerritorio [
    | cantidad origen disponibles objetivos primero candidato |
    cantidad := unaNave arma cantidadDeObjetivos.
    cantidad = 0 ifTrue: [ ^ #() ].
    origen := territorio origenDe: unaNave.
    disponibles := self
        coordenadasDisponiblesDesde: origen
        alcance: unaNave arma alcance
        en: unTablero
        rival: unTerritorio.
    objetivos := OrderedCollection new.
    ultimoImpacto notNil ifTrue: [
        primero := (self vecinosDe: ultimoImpacto)
            detect: [ :c | disponibles includes: c ]
            ifNone: [ nil ].
        primero notNil ifTrue: [ objetivos add: primero ] ].
    [ objetivos size < cantidad ] whileTrue: [
        candidato := disponibles atRandom: azar.
        (objetivos includes: candidato) ifFalse: [ objetivos add: candidato ] ].
    ^ objetivos asArray
]

{ #category : 'testing' }
JugadorIA >> esAutomatico [
    ^ true

]

{ #category : 'actions' }
JugadorIA >> jugarTurno: unaPartida [
    | candidatas nave objetivos resultados |
    unaPartida estaFinalizada ifTrue: [ ^ self ].
    candidatas := self
        navesConObjetivosEn: unaPartida tablero
        rival: (unaPartida rivalDe: self) territorio.
    candidatas isEmpty ifTrue: [ ^ self reubicarOPasar: unaPartida ].
    nave := candidatas atRandom: azar.
    objetivos := self
        elegirObjetivosPara: nave
        en: unaPartida tablero
        rival: (unaPartida rivalDe: self) territorio.
    resultados := unaPartida atacarCon: nave objetivos: objetivos.
    self recordarImpactoDe: resultados
]

{ #category : 'private' }
JugadorIA >> navesConObjetivosEn: unTablero rival: unTerritorio [
    ^ flota navesQuePuedenAtacar select: [ :cadaNave |
        | origen |
        origen := territorio origenDe: cadaNave.
        (cadaNave puedeAlcanzarAlgoDesde: origen contra: unTerritorio)
            and: [ (self
                coordenadasDisponiblesDesde: origen
                alcance: cadaNave arma alcance
                en: unTablero
                rival: unTerritorio) size >= cadaNave arma cantidadDeObjetivos ] ]
]

{ #category : 'actions' }
JugadorIA >> prepararMinasEn: unTablero contra: unTerritorioRival [
    unTablero ubicarMinasAlAzar: 3 en: unTerritorioRival azar: azar
]

{ #category : 'actions' }
JugadorIA >> prepararNavesEn: unTablero [
    flota naves do: [ :cadaNave |
        unTablero ubicarAlAzar: cadaNave en: territorio azar: azar ]
]

{ #category : 'actions' }
JugadorIA >> recordarImpactoDe: unosResultados [
    | impactos |
    impactos := unosResultados select: [ :r | r esImpacto and: [ r esHundido not ] ].
    ultimoImpacto := impactos isEmpty ifTrue: [ nil ] ifFalse: [ impactos first coordenada ]
]

{ #category : 'private' }
JugadorIA >> reubicarOPasar: unaPartida [
    | candidatas nave |
    ultimoImpacto := nil.
    candidatas := flota navesOperativas select: [ :cadaNave |
        cadaNave
            puedeReubicarseDesde: (territorio origenDe: cadaNave)
            contra: unaPartida tablero
            rival: (unaPartida rivalDe: self) territorio ].
    candidatas isEmpty ifTrue: [ ^ unaPartida pasarTurno ].
    nave := candidatas atRandom: azar.
    1 to: 100 do: [ :intento |
        [ unaPartida
            reubicar: nave
            desde: (unaPartida tablero coordenadaAlAzarEn: territorio azar: azar)
            orientacion: (#(#horizontal #vertical) atRandom: azar).
          ^ self ]
            on: UbicacionInvalida
            do: [ :error | error return ] ].
    unaPartida pasarTurno
]

{ #category : 'initialization' }
JugadorIA >> setAzar: unRandom [
    azar := unRandom
]

{ #category : 'private' }
JugadorIA >> vecinosDe: unaCoordenada [
    ^ {
        Coordenada fila: unaCoordenada fila - 1 columna: unaCoordenada columna.
        Coordenada fila: unaCoordenada fila + 1 columna: unaCoordenada columna.
        Coordenada fila: unaCoordenada fila columna: unaCoordenada columna - 1.
        Coordenada fila: unaCoordenada fila columna: unaCoordenada columna + 1 }
]
