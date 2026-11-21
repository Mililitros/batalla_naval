"
Arma básica del Destructor de corto alcance que impacta una única casilla y concede un disparo extra si acierta

"
Class {
	#name : 'Canion',
	#superclass : 'Arma',
	#category : 'BatallaNaval-Disparos',
	#package : 'BatallaNaval-Disparos'
}

{ #category : 'accessing' }
Canion >> alcance [
    ^ 12

]

{ #category : 'accessing' }
Canion >> cantidadDeObjetivos [
    ^ 1

]

{ #category : 'accessing' }
Canion >> coordenadasAfectadasPor: unasCoordenadas en: unTablero rival: unTerritorio [
    ^ unasCoordenadas


]
