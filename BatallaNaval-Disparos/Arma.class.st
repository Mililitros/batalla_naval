"
Clase abstracta que define el comportamiento base, alcance y validación de objetivos para los distintos tipos de disparo de las naves

"
Class {
	#name : 'Arma',
	#superclass : 'Object',
	#category : 'BatallaNaval-Disparos',
	#package : 'BatallaNaval-Disparos'
}

{ #category : 'accessing' }
Arma >> alcance [
    ^ self subclassResponsibility
]

{ #category : 'testing' }
Arma >> alcanzaAlgunaCasillaDe: unTerritorio desde: unOrigen [
    ^ (unTerritorio filaInicial to: unTerritorio filaFinal) anySatisfy: [ :fila |
        (fila - unOrigen fila) abs <= self alcance ]

]

{ #category : 'accessing' }
Arma >> cantidadDeObjetivos [
    ^ self subclassResponsibility

]

{ #category : 'calculating' }
Arma >> coordenadasAfectadasPor: unasCoordenadas en: unTablero rival: unTerritorio [
    ^ self subclassResponsibility

]

{ #category : 'attacking' }
Arma >> disparar: unasCoordenadas desde: unOrigen contra: unTablero rival: unTerritorio [
    | casillasAfectadas |
    self validarObjetivos: unasCoordenadas desde: unOrigen en: unTablero rival: unTerritorio.
    casillasAfectadas := (self coordenadasAfectadasPor: unasCoordenadas en: unTablero rival: unTerritorio)
        collect: [ :cadaCoordenada | unTablero casillaEn: cadaCoordenada ].
    ^ (casillasAfectadas select: [ :cadaCasilla | cadaCasilla puedeRecibirDisparo ])
        collect: [ :cadaCasilla | self impactarEn: cadaCasilla ]
]

{ #category : 'attacking' }
Arma >> impactarEn: unaCasilla [
    ^ unaCasilla recibirDisparo
]

{ #category : 'validating' }
Arma >> validarObjetivos: unasCoordenadas desde: unOrigen en: unTablero rival: unTerritorio [
    unasCoordenadas size = self cantidadDeObjetivos
        ifFalse: [ ^ ObjetivosInvalidos new signal: 'Cantidad de objetivos incorrecta' ].
    unasCoordenadas asSet size = unasCoordenadas size
        ifFalse: [ ^ ObjetivosInvalidos new signal: 'Los objetivos deben ser distintos' ].
    unasCoordenadas do: [ :cadaCoordenada |
        (unTerritorio incluye: cadaCoordenada)
            ifFalse: [ ^ ObjetivosInvalidos new signal: 'El objetivo debe estar en el campo rival' ].
        (cadaCoordenada fila - unOrigen fila) abs <= self alcance
            ifFalse: [ ^ ObjetivosInvalidos new signal: 'El objetivo está fuera de alcance' ].
        (unTablero casillaEn: cadaCoordenada) estaAtacada
            ifTrue: [ ^ CasillaYaAtacada new signal: 'Esa casilla ya fue atacada' ] ]
]
