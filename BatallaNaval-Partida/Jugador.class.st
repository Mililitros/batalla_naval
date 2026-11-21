"
Representa a un participante de la partida, administrando su flota, territorio asignado y cantidad de minas disponibles

"
Class {
	#name : 'Jugador',
	#superclass : 'Object',
	#instVars : [
		'nombre',
		'flota',
		'territorio',
		'minasRestantes'
	],
	#category : 'BatallaNaval-Partida',
	#package : 'BatallaNaval-Partida'
}

{ #category : 'instance creation' }
Jugador class >> nombre: unNombre territorio: unTerritorio [
    ^ self new setNombre: unNombre territorio: unTerritorio

]

{ #category : 'actions' }
Jugador >> avanzarRecargas [
    flota avanzarRecargas
]

{ #category : 'testing' }
Jugador >> esAutomatico [
    ^ false
]

{ #category : 'accessing' }
Jugador >> flota [
    ^ flota
]

{ #category : 'initialization' }
Jugador >> initialize [
    super initialize.
    minasRestantes := 3
]

{ #category : 'accessing' }
Jugador >> minasRestantes [
    ^ minasRestantes

]

{ #category : 'accessing' }
Jugador >> navesOperativas [
    ^ flota navesOperativas

]

{ #category : 'accessing' }
Jugador >> navesSinUbicar [
    ^ flota naves reject: [ :cadaNave | cadaNave estaUbicada ]

]

{ #category : 'accessing' }
Jugador >> nombre [
    ^ nombre
]

{ #category : 'testing' }
Jugador >> perdio [
    ^ flota todasHundidas
]

{ #category : 'initialization' }
Jugador >> setNombre: unNombre territorio: unTerritorio [
    nombre := unNombre.
    territorio := unTerritorio.
    flota := Flota estandar

]

{ #category : 'accessing' }
Jugador >> territorio [
    ^ territorio

]

{ #category : 'actions' }
Jugador >> usarMina [
    minasRestantes := minasRestantes - 1

]
