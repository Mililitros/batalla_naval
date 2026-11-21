"
Representa la cuadrícula de juego donse se ubican las naves y las minas y se reciben disparos. administra las casillas y valida las posiciones
"
Class {
	#name : 'Tablero',
	#superclass : 'Object',
	#instVars : [
		'filas',
		'columnas',
		'casillas'
	],
	#category : 'BatallaNaval-Tablero',
	#package : 'BatallaNaval-Tablero'
}

{ #category : 'as yet unclassified' }
Tablero class >> estandar [
    ^ self filas: 24 columnas: 12
]

{ #category : 'as yet unclassified' }
Tablero class >> filas: cantidadDeFilas columnas: cantidadDeColumnas [
    ^ self new setFilas: cantidadDeFilas columnas: cantidadDeColumnas
]

{ #category : 'initialization' }
Tablero >> cantidadDeCasillas [
    ^ casillas size

]

{ #category : 'accessing' }
Tablero >> cantidadDeIslasEn: unTerritorio [
    ^ (casillas select: [ :c | (unTerritorio incluye: c coordenada) and: [ c terreno esIsla ] ]) size
]

{ #category : 'accessing' }
Tablero >> cantidadDeMinasEn: unTerritorio [
    ^ (casillas select: [ :c | (unTerritorio incluye: c coordenada) and: [ c tieneMina ] ]) size
]

{ #category : 'initialization' }
Tablero >> casillaEn: unaCoordenada [
    (self coordenadaValida: unaCoordenada)
        ifFalse: [ ^ CoordenadaFueraDelTablero new signal: 'Coordenada fuera del tablero' ].
    ^ casillas at: unaCoordenada

]

{ #category : 'accessing' }
Tablero >> columnas [
    ^ columnas

]

{ #category : 'private' }
Tablero >> coordenadaAlAzarEn: unTerritorio azar: unRandom [
    ^ Coordenada
        fila: ((unTerritorio filaInicial to: unTerritorio filaFinal) atRandom: unRandom)
        columna: ((1 to: columnas) atRandom: unRandom)
]

{ #category : 'initialization' }
Tablero >> coordenadaValida: unaCoordenada [
    ^ (unaCoordenada fila between: 1 and: filas)
        and: [ unaCoordenada columna between: 1 and: columnas ]
]

{ #category : 'initialization' }
Tablero >> coordenadasDe: unaNave desde: inicio orientacion: unaOrientacion [
    (#(#horizontal #vertical) includes: unaOrientacion)
        ifFalse: [ ^ UbicacionInvalida new signal: 'La orientación debe ser horizontal o vertical' ].
    ^ (0 to: unaNave tamano - 1) collect: [ :paso |
        unaOrientacion = #horizontal
            ifTrue: [ Coordenada fila: inicio fila columna: inicio columna + paso ]
            ifFalse: [ Coordenada fila: inicio fila + paso columna: inicio columna ] ]
]

{ #category : 'accessing' }
Tablero >> filas [
    ^ filas

]

{ #category : 'positioning' }
Tablero >> generarIslas: cantidad en: unTerritorio azar: unRandom [
    | colocadas |
    colocadas := 0.
    [ colocadas < cantidad ] whileTrue: [
        | casilla |
        casilla := self casillaEn: (self coordenadaAlAzarEn: unTerritorio azar: unRandom).
        casilla terreno esIsla ifFalse: [
            casilla ubicarIsla.
            colocadas := colocadas + 1 ] ]
]

{ #category : 'positioning' }
Tablero >> reubicarNave: unaNave desde: unaCoordenada orientacion: unaOrientacion en: unTerritorio [
    | coordenadas |
    unaNave cantidadDeImpactos > 0
        ifTrue: [ ^ UbicacionInvalida new signal: 'Una nave dañada no puede reubicarse' ].
    coordenadas := self coordenadasDe: unaNave desde: unaCoordenada orientacion: unaOrientacion.
    self validarUbicacion: coordenadas en: unTerritorio ignorando: unaNave.
    unaNave posiciones do: [ :cadaCoordenada | (self casillaEn: cadaCoordenada) liberar ].
    unaNave posicionarEn: coordenadas.
    coordenadas do: [ :cadaCoordenada | (self casillaEn: cadaCoordenada) ocuparCon: unaNave ]
]

{ #category : 'initialization' }
Tablero >> setFilas: cantidadDeFilas columnas: cantidadDeColumnas [
    filas := cantidadDeFilas.
    columnas := cantidadDeColumnas.
    casillas := Dictionary new.
    1 to: filas do: [ :fila |
        1 to: columnas do: [ :columna |
            | coordenada |
            coordenada := Coordenada fila: fila columna: columna.
            casillas at: coordenada put: (Casilla coordenada: coordenada) ] ]

]

{ #category : 'positioning' }
Tablero >> ubicarAlAzar: unaNave en: unTerritorio azar: unRandom [
    | colocada |
    colocada := false.
    [ colocada ] whileFalse: [
        [ self
            ubicarNave: unaNave
            desde: (self coordenadaAlAzarEn: unTerritorio azar: unRandom)
            orientacion: (#(#horizontal #vertical) atRandom: unRandom)
            en: unTerritorio.
          colocada := true ]
            on: UbicacionInvalida
            do: [ :error | error return ] ]
]

{ #category : 'positioning' }
Tablero >> ubicarIslaEn: unaCoordenada [
    (self casillaEn: unaCoordenada) ubicarIsla

]

{ #category : 'positioning' }
Tablero >> ubicarMinaEn: unaCoordenada en: unTerritorio [
    (unTerritorio incluye: unaCoordenada)
        ifFalse: [ ^ UbicacionInvalida new signal: 'La mina debe ir en el territorio indicado' ].
    (self casillaEn: unaCoordenada) ubicarMina

]

{ #category : 'positioning' }
Tablero >> ubicarMinasAlAzar: cantidad en: unTerritorio azar: unRandom [
    | colocadas |
    colocadas := 0.
    [ colocadas < cantidad ] whileTrue: [
        [ self
            ubicarMinaEn: (self coordenadaAlAzarEn: unTerritorio azar: unRandom)
            en: unTerritorio.
          colocadas := colocadas + 1 ]
            on: UbicacionInvalida
            do: [ :error | error return ] ]
]

{ #category : 'initialization' }
Tablero >> ubicarNave: unaNave desde: unaCoordenada orientacion: unaOrientacion en: unTerritorio [
    | coordenadas |
    coordenadas := self coordenadasDe: unaNave desde: unaCoordenada orientacion: unaOrientacion.
    self validarUbicacion: coordenadas en: unTerritorio ignorando: nil.
    unaNave posicionarEn: coordenadas.
    coordenadas do: [ :cadaCoordenada | (self casillaEn: cadaCoordenada) ocuparCon: unaNave ]
]

{ #category : 'initialization' }
Tablero >> validarUbicacion: coordenadas en: unTerritorio ignorando: unaNave [
    coordenadas do: [ :cadaCoordenada |
        | casilla |
        ((self coordenadaValida: cadaCoordenada) and: [ unTerritorio incluye: cadaCoordenada ])
            ifFalse: [ ^ UbicacionInvalida new signal: 'La nave se sale de su territorio' ].
        casilla := self casillaEn: cadaCoordenada.
        (casilla permiteColocacion or: [ unaNave notNil and: [ casilla nave == unaNave ] ])
            ifFalse: [ ^ UbicacionInvalida new signal: 'No se puede ubicar en ', cadaCoordenada comoTexto ] ]
]

{ #category : 'accessing' }
Tablero >> vistaCompleta [
    ^ (1 to: filas) collect: [ :fila |
        (1 to: columnas) collect: [ :columna |
            (self casillaEn: (Coordenada fila: fila columna: columna)) simboloCompleto ] ]

]

{ #category : 'accessing' }
Tablero >> vistaPara: unTerritorioPropio [
    ^ (1 to: filas) collect: [ :fila |
        (1 to: columnas) collect: [ :columna |
            | casilla |
            casilla := self casillaEn: (Coordenada fila: fila columna: columna).
            (unTerritorioPropio incluye: casilla coordenada)
                ifTrue: [ casilla simboloCompleto ]
                ifFalse: [ casilla simboloOculto ] ] ]
]
