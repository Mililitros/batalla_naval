Class {
	#name : 'Torpedo',
	#superclass : 'Arma',
	#category : 'BatallaNaval-Disparos',
	#package : 'BatallaNaval-Disparos'
}

{ #category : 'accessing' }
Torpedo >> alcance [
    ^ 24

]

{ #category : 'accessing' }
Torpedo >> cantidadDeObjetivos [
    ^ 0

]

{ #category : 'accessing' }
Torpedo >> disparar: unasCoordenadas desde: unOrigen contra: unTablero rival: unTerritorio [

    | direccion fila |
    direccion := unTerritorio filaInicial < unOrigen fila ifTrue: [ -1 ] ifFalse: [ 1 ].
    fila := unOrigen fila + direccion.
    [ unTablero coordenadaValida: (Coordenada fila: fila columna: unOrigen columna) ] whileTrue: [

        | coordenada casilla |
        coordenada := Coordenada fila: fila columna: unOrigen columna.
        casilla := unTablero casillaEn: coordenada.
        casilla terreno esIsla ifTrue: [ ^ { casilla recibirDisparo } ].
        ((unTerritorio incluye: coordenada) and: [ casilla estaOcupada and: [ casilla estaAtacada not ] ])
            ifTrue: [ ^ { casilla recibirDisparo } ].
        fila := fila + direccion ].
    ^ { ResultadoAgua new }

]
