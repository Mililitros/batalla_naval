"
Arma del Portaaviones con alcance global que permite impactar dos casillas independientes ignorando el bloqueo de las islas

"
Class {
	#name : 'BombardeoAereo',
	#superclass : 'Arma',
	#category : 'BatallaNaval-Disparos',
	#package : 'BatallaNaval-Disparos'
}

{ #category : 'accessing' }
BombardeoAereo >> alcance [
    ^ 24

]

{ #category : 'accessing' }
BombardeoAereo >> cantidadDeObjetivos [
    ^ 2


]

{ #category : 'calculating' }
BombardeoAereo >> coordenadasAfectadasPor: unasCoordenadas en: unTablero rival: unTerritorio [
    ^ unasCoordenadas



]

{ #category : 'attacking' }
BombardeoAereo >> impactarEn: unaCasilla [
    ^ unaCasilla recibirBombardeo

]
