"
Decisión de un jugador automático para su turno (atacar, reubicar o pasar).
"
Class {
	#name : 'PlanDeTurno',
	#superclass : 'Object',
	#instVars : [
		'tipo',
		'nave',
		'objetivos'
	],
	#category : 'BatallaNaval-Partida',
	#package : 'BatallaNaval-Partida'
}

{ #category : 'instance creation' }
PlanDeTurno class >> ataque: unaNave objetivos: unosObjetivos [
	^ self new setTipo: #ataque nave: unaNave objetivos: unosObjetivos
]

{ #category : 'instance creation' }
PlanDeTurno class >> nada [
	^ self new setTipo: #nada nave: nil objetivos: #()
]

{ #category : 'instance creation' }
PlanDeTurno class >> pasar [
	^ self new setTipo: #pasar nave: nil objetivos: #()
]

{ #category : 'instance creation' }
PlanDeTurno class >> reubicar: unaNave [
	^ self new setTipo: #reubicar nave: unaNave objetivos: #()
]

{ #category : 'testing' }
PlanDeTurno >> esAtaque [
	^ tipo = #ataque
]

{ #category : 'testing' }
PlanDeTurno >> esReubicacion [
	^ tipo = #reubicar
]

{ #category : 'accessing' }
PlanDeTurno >> nave [
	^ nave
]

{ #category : 'accessing' }
PlanDeTurno >> objetivos [
	^ objetivos
]

{ #category : 'initialization' }
PlanDeTurno >> setTipo: unTipo nave: unaNave objetivos: unosObjetivos [
	tipo := unTipo.
	nave := unaNave.
	objetivos := unosObjetivos
]

{ #category : 'accessing' }
PlanDeTurno >> tipo [
	^ tipo
]
