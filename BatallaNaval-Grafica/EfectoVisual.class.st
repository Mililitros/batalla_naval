"
Efecto animado breve sobre un tablero (proyectil, estela, estallido).
"
Class {
	#name : 'EfectoVisual',
	#superclass : 'Object',
	#instVars : [
		'tipo',
		'coordenada',
		'inicio',
		'duracion',
		'deAbajo',
		'columna',
		'territorio'
	],
	#category : 'BatallaNaval-Grafica',
	#package : 'BatallaNaval-Grafica'
}

{ #category : 'instance creation' }
EfectoVisual class >> estela: unaColumna territorio: unTerritorio deAbajo: unBooleano duracion: unaDuracion [
	^ self new setTipo: #estela coordenada: nil inicio: Time millisecondClockValue duracion: unaDuracion deAbajo: unBooleano columna: unaColumna territorio: unTerritorio
]

{ #category : 'instance creation' }
EfectoVisual class >> proyectil: unaCoordenada deAbajo: unBooleano retraso: unRetraso duracion: unaDuracion [
	^ self new setTipo: #proyectil coordenada: unaCoordenada inicio: Time millisecondClockValue + unRetraso duracion: unaDuracion deAbajo: unBooleano columna: nil territorio: nil
]

{ #category : 'instance creation' }
EfectoVisual class >> tipo: unTipo coordenada: unaCoordenada retraso: unRetraso [
	| duracion |
	duracion := unTipo = #hundido ifTrue: [ 1300 ] ifFalse: [ unTipo = #agua ifTrue: [ 1000 ] ifFalse: [ 800 ] ].
	^ self new setTipo: unTipo coordenada: unaCoordenada inicio: Time millisecondClockValue + unRetraso duracion: duracion deAbajo: false columna: nil territorio: nil
]

{ #category : 'accessing' }
EfectoVisual >> columna [
	^ columna
]

{ #category : 'accessing' }
EfectoVisual >> coordenada [
	^ coordenada
]

{ #category : 'accessing' }
EfectoVisual >> deAbajo [
	^ deAbajo
]

{ #category : 'accessing' }
EfectoVisual >> progreso: ahora [
	"0 al empezar, 1 al terminar; negativo si todavía no empezó."
	^ ((ahora - inicio) / duracion) asFloat
]

{ #category : 'initialization' }
EfectoVisual >> setTipo: unTipo coordenada: unaCoordenada inicio: unInicio duracion: unaDuracion deAbajo: unBooleano columna: unaColumna territorio: unTerritorio [
	tipo := unTipo.
	coordenada := unaCoordenada.
	inicio := unInicio.
	duracion := unaDuracion.
	deAbajo := unBooleano.
	columna := unaColumna.
	territorio := unTerritorio
]

{ #category : 'accessing' }
EfectoVisual >> territorio [
	^ territorio
]

{ #category : 'accessing' }
EfectoVisual >> tipo [
	^ tipo
]

{ #category : 'testing' }
EfectoVisual >> vencido: ahora [
	^ ahora > (inicio + duracion + 50)
]
