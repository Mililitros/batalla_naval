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
	^ (self tamanosDeIslasEn: unTerritorio) size
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

{ #category : 'private' }
Tablero >> formaDeIslaDeTamano: unTamano desde: unInicio azar: unRandom [
	"Hace crecer la isla de a una casilla pegada a las anteriores, así queda siempre conectada."
	| casillasDeLaIsla vecinas |
	casillasDeLaIsla := OrderedCollection with: unInicio.
	[ casillasDeLaIsla size < unTamano ] whileTrue: [
		vecinas := OrderedCollection new.
		casillasDeLaIsla do: [ :cadaCoordenada |
			(self vecinasOrtogonalesDe: cadaCoordenada) do: [ :cadaVecina |
				(casillasDeLaIsla includes: cadaVecina) ifFalse: [ vecinas add: cadaVecina ] ] ].
		casillasDeLaIsla add: (vecinas atRandom: unRandom) ].
	^ casillasDeLaIsla
]

{ #category : 'positioning' }
Tablero >> generarIslas: cantidad en: unTerritorio azar: unRandom [
	"Ubica 'cantidad' islas de 3 o 4 casillas conectadas dentro del territorio, sin que se toquen entre sí."
	| colocadas intentos |
	colocadas := 0.
	intentos := 0.
	[ colocadas < cantidad and: [ intentos < 1000 ] ] whileTrue: [
		intentos := intentos + 1.
		(self intentarUbicarIslaEn: unTerritorio azar: unRandom)
			ifTrue: [ colocadas := colocadas + 1 ] ]
]

{ #category : 'positioning' }
Tablero >> intentarUbicarIslaEn: unTerritorio azar: unRandom [
	| forma |
	forma := self
		formaDeIslaDeTamano: ((3 to: 4) atRandom: unRandom)
		desde: (self coordenadaAlAzarEn: unTerritorio azar: unRandom)
		azar: unRandom.
	(self puedeUbicarIsla: forma en: unTerritorio) ifFalse: [ ^ false ].
	forma do: [ :cadaCoordenada | self ubicarIslaEn: cadaCoordenada ].
	^ true
]

{ #category : 'private' }
Tablero >> puedeUbicarIsla: unaForma en: unTerritorio [
	"Entra en el tablero y en el territorio, no pisa otra isla y no toca a ninguna (ni en diagonal)."
	^ unaForma allSatisfy: [ :cadaCoordenada |
		(unTerritorio incluye: cadaCoordenada) and: [
			(self coordenadaValida: cadaCoordenada) and: [
				(self casillaEn: cadaCoordenada) terreno esIsla not and: [
					(self vecinasDe: cadaCoordenada) allSatisfy: [ :cadaVecina |
						(unaForma includes: cadaVecina) or: [ (self casillaEn: cadaVecina) terreno esIsla not ] ] ] ] ] ]
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

{ #category : 'accessing' }
Tablero >> tamanosDeIslasEn: unTerritorio [
	"Cantidad de casillas de cada isla del territorio (una isla es un grupo de casillas conectadas)."
	| pendientes tamanos |
	pendientes := (casillas select: [ :c | (unTerritorio incluye: c coordenada) and: [ c terreno esIsla ] ]) keys asOrderedCollection.
	tamanos := OrderedCollection new.
	[ pendientes isEmpty ] whileFalse: [
		| frontera tamano |
		frontera := OrderedCollection with: pendientes removeFirst.
		tamano := 0.
		[ frontera isEmpty ] whileFalse: [
			| actual |
			actual := frontera removeFirst.
			tamano := tamano + 1.
			(self vecinasOrtogonalesDe: actual) do: [ :cadaVecina |
				(pendientes includes: cadaVecina) ifTrue: [
					pendientes remove: cadaVecina.
					frontera add: cadaVecina ] ] ].
		tamanos add: tamano ].
	^ tamanos
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

{ #category : 'private' }
Tablero >> vecinasDe: unaCoordenada [
	"Las 8 casillas que rodean a la coordenada (las que están dentro del tablero)."
	| vecinas |
	vecinas := OrderedCollection new.
	-1 to: 1 do: [ :deltaFila |
		-1 to: 1 do: [ :deltaColumna |
			(deltaFila = 0 and: [ deltaColumna = 0 ]) ifFalse: [
				| candidata |
				candidata := Coordenada fila: unaCoordenada fila + deltaFila columna: unaCoordenada columna + deltaColumna.
				(self coordenadaValida: candidata) ifTrue: [ vecinas add: candidata ] ] ] ].
	^ vecinas
]

{ #category : 'private' }
Tablero >> vecinasOrtogonalesDe: unaCoordenada [
	^ {
		Coordenada fila: unaCoordenada fila - 1 columna: unaCoordenada columna.
		Coordenada fila: unaCoordenada fila + 1 columna: unaCoordenada columna.
		Coordenada fila: unaCoordenada fila columna: unaCoordenada columna - 1.
		Coordenada fila: unaCoordenada fila columna: unaCoordenada columna + 1 }
			select: [ :cadaCoordenada | self coordenadaValida: cadaCoordenada ]
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
