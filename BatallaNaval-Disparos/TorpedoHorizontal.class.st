"
Arma del Crucero de alcance medio que impacta tres casillas horizontales contiguas 
"
Class {
	#name : 'TorpedoHorizontal',
	#superclass : 'Arma',
	#category : 'BatallaNaval-Disparos',
	#package : 'BatallaNaval-Disparos'
}

{ #category : 'accessing' }
TorpedoHorizontal >> alcance [
    ^ 14

]

{ #category : 'accessing' }
TorpedoHorizontal >> cantidadDeObjetivos [
    ^ 1


]

{ #category : 'accessing' }
TorpedoHorizontal >> coordenadasAfectadasPor: unasCoordenadas en: unTablero rival: unTerritorio [

    | centro |
    centro := unasCoordenadas first.
    ^ ((centro columna - 1 to: centro columna + 1)
        collect: [ :columna | Coordenada fila: centro fila columna: columna ])
        select: [ :c | unTablero coordenadaValida: c ]

]
